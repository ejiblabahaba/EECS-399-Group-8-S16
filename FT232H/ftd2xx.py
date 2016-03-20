import sys

if sys.platform == 'win32':
	import _ftd2xx as _ft

import ctypes as c
from defines import *

msgs = ['FT_OK', 'FT_INVALID_HANDLE', 'FT_DEVICE_NOT_FOUND', 'FT_DEVICE_NOT_OPENED',
		'FT_IO_ERROR', 'FT_INSUFFICIENT_RESOURCES', 'FT_INVALID_PARAMETER',
		'FT_INVALID_BAUD_RATE', 'FT_DEVICE_NOT_OPENED_FOR_ERASE',
		'FT_DEVICE_NOT_OPENED_FOR_WRITE', 'FT_FAILED_TO_WRITE_DEVICE',
		'FT_EEPROM_READ_FAILED', 'FT_EEPROM_WRITE_FAILED', 'FT_EEPROM_ERASE_FAILED',
		'FT_EEPROM_NOT_PRESENT', 'FT_EEPROM_NOT_PROGRAMMED', 'FT_INVALID_ARGS',
		'FT_NOT_SUPPORTED', 'FT_OTHER_ERROR']

class DeviceError(Exception):
	"""Exception Class for status messages"""
	def __init__(self, msgnum):
		self.message = msgs[msgnum]

	def __str__(self):
		return self.message

def call_ft(function, *args):
	"""Calls FTDI function, checks status, raises exception on error"""
	status = function(*args)
	if status != FT_OK:
		raise DeviceError(status)

def listDevices(flags=0):
	"""Return a list of serial numbers (default), descriptions or locations
	(Windows only) of the connected FTDI devices depending on value of flags.
	"""
	n = _ft.DWORD()
	call_ft(_ft.FT_ListDevices, c.byref(n), None, _ft.DWORD(FT_LIST_NUMBERS_ONLY))
	devcount = n.value
	if devcount:
		# since ctypes has no pointer arithmetic.
		bd = [c.c_buffer(MAX_DESCRIPTION_SIZE) for i in range(devcount)] +\
			[None]
		# array of pointers to those strings, initially all NULL
		ba = (c.c_char_p *(devcount + 1))()
		for i in range(devcount):
			ba[i] = c.cast(bd[i], c.c_char_p)
		call_ft(_ft.FT_ListDevices, ba, c.byref(n), _ft.DWORD(FT_LIST_ALL|flags))
		return [res for res in ba[:devcount]]
	else:
		return None

def createDeviceInfoList():
	lpdwNumDevs = _ft.DWORD()
	call_ft(_ft.FT_CreateDeviceInfoList, c.byref(lpdwNumDevs))
	return lpdwNumDevs.value

def open(dev=0):
	"""Open a handle to a usb device by index and return an FTD2XX instance for
	it"""
	h = _ft.FT_HANDLE()
	call_ft(_ft.FT_Open, dev, c.byref(h))
	return FTD2XX(h)

def openEx(id_str, flags=FT_OPEN_BY_SERIAL_NUMBER):
	"""Open a handle to a usb device by serial number(default), description or
	location(Windows only) depending on value of flags and return an FTD2XX
	instance for it"""
	h = _ft.FT_HANDLE()
	call_ft(_ft.FT_OpenEx, id_str, _ft.DWORD(flags), c.byref(h))
	return FTD2XX(h)

class FTD2XX(object):
	"""Class for communicating with an FTDI device"""
	def __init__(self, handle, update=True):
		"""Create an instance of the FTD2XX class with the given device handle
		and populate the device info in the instance dictionary. Set
		update to False to avoid a slow call to createDeviceInfoList."""
		self.handle = handle
		self.status = 1
		# createDeviceInfoList is slow, only run if update is True
		if update: createDeviceInfoList()
		self.__dict__.update(self.getDeviceInfo())

	def close(self):
		"""Close the device handle"""
		call_ft(_ft.FT_Close, self.handle)
		self.status = 0

	def read(self, nchars, raw=True):
		"""Read up to nchars bytes of data from the device. Can return fewer if
		timedout. Use getQueueStatus to find how many bytes are available"""
		b_read = _ft.DWORD()
		b = c.c_buffer(nchars)
		call_ft(_ft.FT_Read, self.handle, b, nchars, c.byref(b_read))
		return b.raw[:b_read.value] if raw else b.value[:b_read.value]

	def write(self, data):
		"""Send the data to the device. Data must be a string representing the
		bytes to be sent"""
		w = _ft.DWORD()
		call_ft(_ft.FT_Write, self.handle, data, len(data), c.byref(w))
		return w.value

	def resetDevice(self):
		"""Reset the device"""
		call_ft(_ft.FT_ResetDevice, self.handle)
		return None

	def purge(self, mask=0):
		if not mask:
			mask = FT_PURGE_RX | FT_PURGE_TX
		call_ft(_ft.FT_Purge, self.handle, _ft.DWORD(mask))
		return None

	def setTimeouts(self, read, write):
		call_ft(_ft.FT_SetTimeouts, self.handle, _ft.DWORD(read),
				_ft.DWORD(write))
		return None

	def getQueueStatus(self):
		"""Get number of bytes in receive queue."""
		rxQAmount = _ft.DWORD()
		call_ft(_ft.FT_GetQueueStatus, self.handle, c.byref(rxQAmount))
		return rxQAmount.value

	def getStatus(self):
		"""Return a 3-tuple of rx queue bytes, tx queue bytes and event
		status"""
		rxQAmount = _ft.DWORD()
		txQAmount = _ft.DWORD()
		evtStatus = _ft.DWORD()
		call_ft(_ft.FT_GetStatus, self.handle, c.byref(rxQAmount),
				c.byref(txQAmount), c.byref(evtStatus))
		return (rxQAmount.value, txQAmount.value, evtStatus.value)

	def setLatencyTimer(self, latency):
		call_ft(_ft.FT_SetLatencyTimer, self.handle, _ft.UCHAR(latency))
		return None

	def getLatencyTimer(self):
		latency = _ft.UCHAR()
		call_ft(_ft.FT_GetLatencyTimer, self.handle, c.byref(latency))
		return latency.value

	def setBitMode(self, mask, enable):
		call_ft(_ft.FT_SetBitMode, self.handle, _ft.UCHAR(mask),
				_ft.UCHAR(enable))
		return None

	def getBitMode(self):
		mask = _ft.UCHAR()
		call_ft(_ft.FT_GetBitMode, self.handle, c.byref(mask))
		return mask.value

	def getDeviceInfo(self):
		"""Returns a dictionary describing the device. """
		deviceType = _ft.DWORD()
		deviceId = _ft.DWORD()
		desc = c.c_buffer(MAX_DESCRIPTION_SIZE)
		serial = c.c_buffer(MAX_DESCRIPTION_SIZE)

		call_ft(_ft.FT_GetDeviceInfo, self.handle, c.byref(deviceType),
				c.byref(deviceId), serial, desc, None)
		return {'type': deviceType.value, 'id': deviceId.value,
				'description': desc.value, 'serial': serial.value}

	def resetPort(self):
		call_ft(_ft.FT_ResetPort, self.handle)
		return None

	def cyclePort(self):
		call_ft(_ft.FT_CyclePort, self.handle)
		return None

__all__ = ['call_ft','listDevices','createDeviceInfoList','open','openEx',
		   'FTD2XX','DeviceError']