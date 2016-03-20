import sys
from ctypes import *

STRING = c_char_p
if sys.platform == 'win32':
	from ctypes.wintypes import DWORD
	from ctypes.wintypes import ULONG
	from ctypes.wintypes import WORD
	from ctypes.wintypes import BYTE
	from ctypes.wintypes import BOOL
	from ctypes.wintypes import BOOLEAN
	from ctypes.wintypes import LPCSTR
	from ctypes.wintypes import HANDLE
	from ctypes.wintypes import LONG
	from ctypes.wintypes import UINT
	from ctypes.wintypes import LPSTR
	from ctypes.wintypes import FILETIME
else:
	DWORD = c_ulong
	ULONG = c_ulong
	WORD = c_ushort
	BYTE = c_ubyte
	BOOL = c_int
	BOOLEAN = c_char
	LPCSTR = STRING
	HANDLE = c_void_p
	LONG = c_long
	UINT = c_uint
	LPSTR = STRING

_libraries = {}

if sys.platform == 'win32':
	_libraries['ftd2xx.dll'] = WinDLL('ftd2xx.dll')
else:
	_libraries['ftd2xx.dll'] = CDLL('libftd2xx.so')

#CTYPE Shenanigans
USHORT = c_ushort
SHORT = c_ushort
UCHAR = c_ubyte
LPBYTE = POINTER(c_ubyte)
CHAR = c_char
LPBOOL = POINTER(c_int)
PUCHAR = POINTER(c_ubyte)
PCHAR = STRING
PVOID = c_void_p
INT = c_int
LPTSTR = STRING
LPDWORD = POINTER(DWORD)
LPWORD = POINTER(WORD)
PULONG = POINTER(ULONG)
LPVOID = PVOID
VOID = None
ULONGLONG = c_ulonglong

#Basic Necessities
FT_HANDLE = PVOID
FT_STATUS = ULONG
FT_DEVICE = ULONG
class _ft_device_list_info_node(Structure):
	pass
_ft_device_list_info_node._fields_ = [
	('Flags', ULONG),
	('Type', ULONG),
	('ID', ULONG),
	('LocId', DWORD),
	('SerialNumber', c_char * 16),
	('Description', c_char * 64),
	('ftHandle', FT_HANDLE)
]
FT_DEVICE_LIST_INFO_NODE = _ft_device_list_info_node

#FT_CreateDeviceInfoList
FT_CreateDeviceInfoList = _libraries['ftd2xx.dll'].FT_CreateDeviceInfoList
FT_CreateDeviceInfoList.restype = FT_STATUS
FT_CreateDeviceInfoList.argtypes = [LPDWORD]
FT_CreateDeviceInfoList.__doc__ = """FT_STATUS FT_CreateDeviceInfoList(LPDWORD lpdwNumDevs)"""

#FT_GetDeviceInfoList
FT_GetDeviceInfoList = _libraries['ftd2xx.dll'].FT_GetDeviceInfoList
FT_GetDeviceInfoList.restype = FT_STATUS
FT_GetDeviceInfoList.argtypes = [POINTER(FT_DEVICE_LIST_INFO_NODE), LPDWORD]
FT_GetDeviceInfoList.__doc__ = """FT_STATUS FT_GetDeviceInfoList(FT_DEVICE_LIST_INFO_NODE *pDest, LPDWORD lpdwNumDevs)"""

#FT_ListDevices
FT_ListDevices = _libraries['ftd2xx.dll'].FT_ListDevices
FT_ListDevices.restype = FT_STATUS
FT_ListDevices.argtypes = [PVOID, PVOID, DWORD]
FT_ListDevices.__doc__ = """FT_STATUS FT_ListDevices(PVOID pvArg1, PVOID pvArg2, DWORD dwFlags)"""

#FT_GetDeviceInfo
FT_GetDeviceInfo = _libraries['ftd2xx.dll'].FT_GetDeviceInfo
FT_GetDeviceInfo.restype = FT_STATUS
FT_GetDeviceInfo.argtypes = [FT_HANDLE, POINTER(FT_DEVICE), LPDWORD, PCHAR, PCHAR, LPVOID]
FT_GetDeviceInfo.__doc__ = """FT_STATUS FT_GetDeviceInfo(FT_HANDLE ftHandle, FT_DEVICE *pftType, LPDWORD lpdwID, PCHAR pcSerialNumber, PCHAR pcDescription, PVOID pvDummy)"""

#FT_Open
FT_Open = _libraries['ftd2xx.dll'].FT_Open
FT_Open.restype = FT_STATUS
FT_Open.argtypes = [c_int, POINTER(FT_HANDLE)]
FT_Open.__doc__ = """FT_STATUS FT_Open(int deviceNumber, FT_HANDLE *ftHandle)"""

#FT_OpenEx
FT_OpenEx = _libraries['ftd2xx.dll'].FT_OpenEx
FT_OpenEx.restype = FT_STATUS
FT_Open.argtypes = [PVOID, DWORD, POINTER(FT_HANDLE)]
FT_OpenEx.__doc__ = """FT_STATUS FT_OpenEx(PVOID pvArg1, DWORD dwFlags, FT_HANDLE *ftHandle)"""

#FT_Close
FT_Close = _libraries['ftd2xx.dll'].FT_Close
FT_Close.restype = FT_STATUS
FT_Close.argtypes = [FT_HANDLE]
FT_Close.__doc__ = """FT_STATUS FT_Close(FT_HANDLE ftHandle)"""

#FT_Read
FT_Read = _libraries['ftd2xx.dll'].FT_Read
FT_Read.restype = FT_STATUS
FT_Read.argtypes = [FT_HANDLE, LPVOID, DWORD, LPDWORD]
FT_Read.__doc__ = """FT_STATUS FT_Read(FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToRead, LPDWORD lpdwBytesReturned)"""

#FT_Write
FT_Write = _libraries['ftd2xx.dll'].FT_Write
FT_Write.restype = FT_STATUS
FT_Write.argtypes = [FT_HANDLE, LPVOID, DWORD, LPDWORD]
FT_Write.__doc__ = """FT_STATUS FT_Write(FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToWrite, LPDWORD lpdwBytesWritten)"""

#FT_SetTimeouts
FT_SetTimeouts = _libraries['ftd2xx.dll'].FT_SetTimeouts
FT_SetTimeouts.restype = FT_STATUS
FT_SetTimeouts.argtypes = [FT_HANDLE, DWORD, DWORD]
FT_SetTimeouts.__doc__ = """FT_STATUS FT_SetTimeouts(FT_HANDLE ftHandle, DWORD dwReadTimeout, DWORD dwWriteTimeout)"""

#FT_GetQueueStatus
FT_GetQueueStatus = _libraries['ftd2xx.dll'].FT_GetQueueStatus
FT_GetQueueStatus.restype = FT_STATUS
FT_GetQueueStatus.argtypes = [FT_HANDLE, LPDWORD]
FT_GetQueueStatus.__doc__ = """FT_STATUS FT_GetQueueStatus(FT_HANDLE ftHandle, LPDWORD lpdwAmountInRxQueue)"""

#FT_GetStatus
FT_GetStatus = _libraries['ftd2xx.dll'].FT_GetStatus
FT_GetStatus.restype = FT_STATUS
FT_GetStatus.argtypes = [FT_HANDLE, LPDWORD, LPDWORD, LPDWORD]
FT_GetStatus.__doc__ = """FT_STATUS FT_GetStatus(FT_HANDLE ftHandle, LPDWORD lpdwAmountInRxQueue, LPDWORD lpdwAmountInTxQueue, LPDWORD lpdwEventStatus)"""

#FT_Purge
FT_Purge = _libraries['ftd2xx.dll'].FT_Purge
FT_Purge.restype = FT_STATUS
FT_Purge.argtypes = [FT_HANDLE, DWORD]
FT_Purge.__doc__ = """FT_STATUS FT_Purge(FT_HANDLE ftHandle, DWORD dwMask)"""

#FT_ResetDevice
FT_ResetDevice = _libraries['ftd2xx.dll'].FT_ResetDevice
FT_ResetDevice.restype = FT_STATUS
FT_ResetDevice.argtypes = [FT_HANDLE]
FT_ResetDevice.__doc__ = """FT_STATUS FT_ResetDevice(FT_HANDLE ftHandle)"""

#FT_ResetPort
FT_ResetPort = _libraries['ftd2xx.dll'].FT_ResetPort
FT_ResetPort.restype = FT_STATUS
FT_ResetPort.argtypes = [FT_HANDLE]
FT_ResetPort.__doc__ = """FT_STATUS FT_ResetPort(FT_HANDLE ftHandle)"""

#FT_CyclePort
FT_CyclePort = _libraries['ftd2xx.dll'].FT_CyclePort
FT_CyclePort.restype = FT_STATUS
FT_CyclePort.argtypes = [FT_HANDLE]
FT_CyclePort.__doc__ = """FT_STATUS FT_CyclePort(FT_HANDLE ftHandle)"""

#FT_Reload
# FT_Reload = _libraries['ftd2xx.dll'].FT_Reload
# FT_Reload.restype = FT_STATUS
# FT_Reload.argtypes = [WORD, WORD]
# FT_Reload.__doc__ = """FT_STATUS FT_Reload(WORD wVID, WORD wPID)"""

#FT_SetLatencyTimer
FT_SetLatencyTimer = _libraries['ftd2xx.dll'].FT_SetLatencyTimer
FT_SetLatencyTimer.restype = FT_STATUS
FT_SetLatencyTimer.argtypes = [FT_HANDLE, UCHAR]
FT_SetLatencyTimer.__doc__ = """FT_STATUS FT_SetLatencyTimer(FT_HANDLE ftHandle, UCHAR ucTimer)"""

#FT_GetLatencyTimer
FT_GetLatencyTimer = _libraries['ftd2xx.dll'].FT_GetLatencyTimer
FT_GetLatencyTimer.restype = FT_STATUS
FT_GetLatencyTimer.argtypes = [FT_HANDLE, PUCHAR]
FT_GetLatencyTimer.__doc__ = """FT_STATUS FT_GetLatencyTimer(FT_HANDLE ftHandle, PUCHAR pucTimer)"""

#FT_SetBitMode
FT_SetBitMode = _libraries['ftd2xx.dll'].FT_SetBitMode
FT_SetBitMode.restype = FT_STATUS
FT_SetBitMode.argtypes = [FT_HANDLE, UCHAR, UCHAR]
FT_SetBitMode.__doc__ = """FT_STATUS FT_SetBitMode(FT_HANDLE ftHandle, UCHAR ucMask, UCHAR ucMode)"""

#FT_GetBitMode
FT_GetBitMode = _libraries['ftd2xx.dll'].FT_GetBitMode
FT_GetBitMode.restype = FT_STATUS
FT_GetBitMode.argtypes = [FT_HANDLE, PUCHAR]
FT_GetBitMode.__doc__ = """FT_HANDLE FT_GetBitMode(FT_HANDLE ftHandle, PUCHAR pucMode)"""

__all__ = ['USHORT','SHORT','UCHAR','LPBYTE','CHAR','LPBOOL','PUCHAR','PCHAR',
		   'PVOID','INT','LPTSTR','LPDWORD','LPWORD','PULONG','LPVOID','VOID',
		   'ULONGLONG', 'FT_HANDLE','FT_STATUS','FT_DEVICE',
		   'FT_CreateDeviceInfoList','FT_GetDeviceInfoList','FT_ListDevices',
		   'FT_GetDeviceInfo','FT_Open','FT_OpenEx','FT_Close','FT_Read',
		   'FT_Write','FT_SetTimeouts','FT_GetQueueStatus','FT_GetStatus',
		   'FT_Purge','FT_ResetDevice','FT_ResetPort','FT_CyclePort',
		   'FT_SetLatencyTimer','FT_GetLatencyTimer','FT_SetBitMode',
		   'FT_GetBitMode']