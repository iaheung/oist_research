from PIL import Image
import os
import io
from logging import getLogger

class Instrument():

	def __init__(self,dic_connect):
		self.logger = getLogger('instr')

		rm = dic_connect['rm']
		visa_cmd = dic_connect['visa_cmd']
		self._instr = rm.open_resource(visa_cmd)
		
		self._name = 'unknown spa?'
		self._name = self._query('*IDN?').split(',')[1]
		self.config = {
			'name':self._name,
			'cmd':visa_cmd,
			}
		self.batch_size =  125000 ## RAW, WAORD format

	def load_waveform(self, chidx, points_request=-1):
		self._write(f':WAV:SOUR CHAN{chidx}')
		self._write(':WAV:MODE RAW')
		self._write(f':WAV:POIN {points_request}')
		self._write(':WAV:FORM word')

		preample = self._query(':WAV:PRE?')[:-1].split(',')
		# print(preample)
		points = int(preample[2])
		# print(points)
		xinc = float(preample[4])
		xorg = float(preample[5])
		xref = float(preample[6])
		yinc = float(preample[7])
		yorg = float(preample[8])
		yref = float(preample[9])

		if points_request==-1:
			# print('read all points')
			# read whole points data
			data_np = np.zeros(points)
			if points//self.batch_size == 0:
				start_point = 1
				end_point = points

				self._write(f':WAV:STAR {start_point}')
				self._write(f':WAV:STOP {end_point}')
				data_bin = self._instr.query_binary_values('WAV:DATA?', datatype='h', container=np.array)
				# print(len(data_bin))
				data_np[start_point-1:end_point] = data_bin
			
			else:
				for nn in range(int(points//self.batch_size)):
					start_point = self.batch_size*nn + 1
					end_point = self.batch_size*(nn+1)
					if end_point>points:
						end_point = points
					self._write(f':WAV:STAR {start_point}')
					self._write(f':WAV:STOP {end_point}')
					data_bin = self._instr.query_binary_values('WAV:DATA?', datatype='h', container=np.array)
					# print(len(data_bin))
					data_np[start_point-1:end_point] = data_bin
			v = [(float(byte_data) - yref - yorg)*yinc  for byte_data in data_np]
			t = [(float(i) - xref - xorg)*xinc for i in range(len(v))]

		elif points_request>points:
			# print('points_request>points')
			self._write(':WAV:MODE NORMal')
			start_point = 0
			end_point = points
			# self._write(f':WAV:STAR {start_point}')
			# self._write(f':WAV:STOP {end_point}')
			data_bin = self._instr.query_binary_values('WAV:DATA?', datatype='h', container=np.array)
			v = [(float(byte_data) - yref - yorg)*yinc  for byte_data in data_bin]
			t = [(float(i) - xref - xorg)*xinc for i in range(len(v))]

		else:
			# print('points_request=<points')
			self._write(':WAV:MODE NORMal')
			data_np = np.zeros(points_request)
			for nn in range(int(points_request//self.batch_size)+1):
				start_point = self.batch_size*nn + 1
				end_point = self.batch_size*(nn+1)
				if end_point>points_request:
					end_point = points_request
				self._write(f':WAV:STAR {start_point}')
				self._write(f':WAV:STOP {end_point}')

				data_bin = self._instr.query_binary_values('WAV:DATA?', datatype='h', container=np.array)
				# print('in ',len(data_bin))
				data_np[start_point-1:end_point] = data_bin
			v = [(float(byte_data) - yref - yorg)*yinc  for byte_data in data_np]
			t = [(float(i) - xref - xorg)*xinc for i in range(len(v))]

		return t,v

	def get_points(self):
		preample = self._query(':WAV:PRE?')[:-1].split(',')
		# print(preample)
		points = int(preample[2])

		return points

	def save_img(self,path):
		bmp_bin = self._instr.query_binary_values(':DISP:DATA?', datatype='B', container=bytes)
		img = Image.open(io.BytesIO(bmp_bin))
		img.save(path)

	##############################
	# Methods that send commands
	##############################
	def _write(self, cmd):
		self.logger.debug("{} write visa cmd: {}".format(self._name,cmd))
		self._instr.write(cmd)

	def _read(self):
		self.logger.debug("{} read instrument".format(self._name))
		val = self._instr.read()
		self.logger.debug("{} -> results of _read: {}".format(self._name,val))
		return val

	def _query(self, cmd):
		self.logger.debug("{} query visa cmd: {}".format(self._name,cmd))
		val =  self._instr.query(cmd)
		self.logger.debug("{} -> {}".format(self._name,val))
		return val



if __name__== "__main__":
	import matplotlib.pyplot as plt 
	import pyvisa as visa
	import numpy as np
	import pandas as pd
	import datetime

	rm = visa.ResourceManager()
	# pprint(rm.list_resources())

	dic_connect = {
		"rm" : rm,
		"visa_cmd" : "TCPIP::192.168.0.10::INSTR"
	}
	inst = Instrument(dic_connect)
	inst._write(':STOP')

	path = 'C:\\Users\\Ian\\Desktop\\OIST'
	now = datetime.datetime.now()

	# Save screen #
	screen_name = 'Osillo_screen_'+now.strftime('%y%m%d_%H%M%S')+'screen.png'
	inst.save_img(os.path.join(path,screen_name))

	ch_list = (1,2,3,4)
	columns = ['time [sec]', 'ch1 [V]', 'ch2 [V]','ch3 [V]', 'ch4 [V]']
	ch_list = (1,2)
	columns = ['time [sec]', 'ch1 [V]', 'ch2 [V]']
	data_len = int(2048)

	points = inst.get_points()
	print(points)
	if data_len == -1:
		result = np.zeros((len(ch_list)+1,points))
	else:
		points = np.min((points,data_len))
		data_len = np.min((points,data_len))
		result = np.zeros((len(ch_list)+1,points))
		# print('test',points)


	
	for i,ch in enumerate(ch_list):
		t, v = inst.load_waveform(ch,data_len)
		# print(v)
		result[i+1,:] = v
		result[0] = t

	df = pd.DataFrame(result.T,columns=columns)
	#print(df)

	csv_name = 'Osillo_'+now.strftime('%y%m%d_%H%M%S')+'.csv'
	# path='D:\\Data\\Maser_data\\202209\\07\\vna_'+now.strftime('%y%m%d_%H%M%S')+'.csv'
	df.to_csv(os.path.join(path,csv_name))
	print(result.shape)

	# Save a plot #
	fig_name = 'Osillo_'+now.strftime('%y%m%d_%H%M%S')+'.png'
	for ii,ch in enumerate(ch_list):
		plt.plot(result[0],result[ii+1],label='ch:'+str(ch))
	plt.legend()
	plt.savefig(os.path.join(path,fig_name))
	# Make a plot #
	# for ii,ch in enumerate(ch_list):
	# 	plt.plot(result[0],result[ii+1],label='ch:'+str(ch))
	# plt.legend()
	plt.show()

	
	# inst._write(':RUN')

