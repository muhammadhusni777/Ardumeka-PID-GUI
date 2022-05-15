#############################################################################################
###########                          ARDUMEKA PID GUI V0.1                     ##############
###########                       from Indonesia to Indonesia                  ##############
###########                          by : husni and friends                    ##############
#############################################################################################


print('#############################################################################################')
print('###########                          ARDUMEKA PID GUI V0.1                     ##############')
print('###########                       from Indonesia to Indonesia                  ##############')
print('###########                          by : husni and friends                    ##############')
print('#############################################################################################')





import time
from datetime import datetime
import sys
import serial
from PyQt5 import QtGui, QtCore, Qt,QtQml
from PyQt5.QtCore import QUrl, QObject, pyqtSignal, pyqtSlot, QTimer, pyqtProperty
from PyQt5.QtCore    import pyqtSlot, pyqtSignal, QUrl, QObject,QStringListModel, Qt
from PyQt5.QtQuick   import QQuickView
from PyQt5.QtWidgets import QApplication, QCheckBox, QGridLayout, QGroupBox
from PyQt5.QtWidgets import QMenu, QPushButton, QRadioButton, QVBoxLayout, QWidget, QSlider
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtGui import QGuiApplication, QIcon
from RadialBar import RadialBar
import threading


import csv

print (datetime.now())

#current_time = dt.datetime.now()



print ("select your arduino port:")

def serial_ports():
    """ Lists serial port names

        :raises EnvironmentError:
            On unsupported or unknown platforms
        :returns:
            A list of the serial ports available on the system
    """
    if sys.platform.startswith('win'):
        ports = ['COM%s' % (i + 1) for i in range(256)]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this excludes your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.*')
    else:
        raise EnvironmentError('Unsupported platform')

    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result
print(str(serial_ports()))

port = input("write port : ")

ser = serial.Serial(port, 9600, timeout=3)



broker="127.0.0.1"
port = 1883

waktu = ""
dt = 0
dt_prev = time.time()


i=0

alpha = 0.0
sensor = 0
sensor_prev = 0
sensor_filtered = 0
error = 0.0
error_prev = 0.0
setpoint = 0.0
kp_control = 0
ki_control = 0
kd_control = 0
p_control = 0.0
i_control = 0.0
d_control = 0.0
pid_control = 0.0
saturation = 1000
i_windup = 1000
offset = 1000
motor = "OFF"
motor_speed = 0

waktu = datetime.now()
print(waktu.day)
title = str("PID DATA " ) + str(waktu.day)+str("-")+str(waktu.month)+str("-")+str(waktu.year) + str(".csv")
fields = ['time','sp', 'sensor','sensor filtered','e', 'p', 'i', 'd','control signal']
filename = title
filename_buffer = str("buffer.csv")

time_n = 0
time_n_prev = 0

analysis = ''
motor_response_equation = ''
step_value = 0
mode = "PID"

power_gui = 0

step_level = 0
motor_command = 0
filter_weight = 0.9

sampling_rate = 0

ser_bytes = '0'
serial_send_time = 0
serial_send_time_prev = 0


connection_type = "SERIAL"

with open(filename, 'a') as csvfile:
    # creating a csv writer object
    csvwriter = csv.writer(csvfile)
    # writing the fields
    csvwriter.writerow(fields)

import os

old_buffer = 'buffer.csv'
if(os.path.exists(old_buffer) and os.path.isfile(old_buffer)):
  os.remove(old_buffer)
  print("file deleted")
else:
  print("file not found")


with open(filename_buffer, 'a') as csvfile:
    csvwriter = csv.writer(csvfile)
    # writing the fields
    csvwriter.writerow(fields)


##########read sensor from serial###############

def serial_read(num):
    global ser_bytes
    global decoded_bytes
    global sensor
    while True:
        try:
            ser_bytes = ser.readline()
            sensor = (ser_bytes.decode('utf-8')[:-2])
            if (sensor ==''):
                sensor = sensor_prev
            #print(sensor)
        
        
        except:
            sensor = sensor



class table(QQuickView):
    sensor_val = pyqtSignal(str)    
    power_val = pyqtSignal(str)
    connection_type_val = pyqtSignal(str)
    
    def __init__(self):
        super().__init__()
        self.setSource(QUrl('main.qml'))
        self.setTitle("ARDUMEKA PID GUI")
        
        self.rootContext().setContextProperty("table", self)
        self.setGeometry(300, 25, 850, 700)
        self.show()
        windows = self.rootObject()
        self.init_tempo()
        self.sensor_val.connect(windows.sensor_val_read)
        self.power_val.connect(windows.power_val_read)
        self.connection_type_val.connect(windows.connection_type_val_read)
        
    def init_tempo(self):
        self.tempo = QtCore.QTimer()
        self.tempo.timeout.connect(self.variable_transfer)
        self.tempo.start(500)
        
        
    def variable_transfer(self):
        self.sensor_val.emit(str(sensor_filtered))
        self.power_val.emit(str(round(motor_command, 0)))
        self.connection_type_val.emit(str(connection_type))    
    
    
    
    @pyqtSlot('QString')
    def motor(self, value):
        global motor
        motor = value
        print(motor)
        
   
    @pyqtSlot('QString')
    def saturation(self, value):
        global saturation
        saturation = float(value)
        
        
    @pyqtSlot('QString')
    def offset(self, value):
        global offset
        offset = float(value)
        
    ########setpoint value from GUI##################
    @pyqtSlot('QString')
    def setpoint(self, value):
        global setpoint
        setpoint = float(value)
        
        
    @pyqtSlot('QString')
    def filter_weight(self, value):
        global filter_weight
        filter_weight = float(value)
       
    
    
    @pyqtSlot('QString')
    def setP_control(self, value):
        global kp_control
        kp_control = float(value)
        #ser.write(alpha.encode())
    
    @pyqtSlot('QString')
    def setI_control(self, value):
        global ki_control
        ki_control = float(value)

        
    @pyqtSlot('QString')
    def setD_control(self, value):
        global kd_control
        kd_control = float(value)

    @pyqtSlot('QString')
    def analysis(self, value):
        global analysis
        analysis = str(value)
        print(analysis)
        
    @pyqtSlot('QString')
    def step_level(self, value):
        global step_level
        step_level = str(value)
        print(step_level)
        
        
    @pyqtSlot('QString')
    def mode(self, value):
        global mode
        mode = str(value)
        print(mode)
        
    
    @pyqtSlot('QString')
    def clear_buffer(self, value):
        old_buffer = 'buffer.csv'
        if(os.path.exists(old_buffer) and os.path.isfile(old_buffer)):
            os.remove(old_buffer)
            print("file deleted")
        else:
          print("file not found")
  
  
  
def timerEvent():
    waktu = datetime.now()
    #print (waktu.day)
    
    global i
    global dt
    global error
    global error_prev
    global sensor
    global sensor_filtered
    global dt_prev
    global p_control
    global kp_control
    global i_control
    global ki_control
    global i_windup
    global d_control
    global kd_control
    global pid_control
    global time_n
    global time_n_prev
    global motor_speed
    global analysis
    global motor_command
    global serial_send_time
    global serial_send_time_prev
    
    
    dt = round(time.time() - dt_prev ,3)
    
    #######sensor filter###################
    sensor_filtered = (float(1-filter_weight) * float(sensor)) + (float(filter_weight) * float(sensor_filtered))
    
    #######calculate error#################
    error = setpoint - sensor_filtered
    
    #######proportional control#############
    p_control = kp_control * error
    
    ########integral control###############
    i_control = round((((ki_control*error * dt) + i_control)),2)
    
    ########integral windup###############
    if (i_control > i_windup):
        i_control = i_windup
    
    
    #########derivative control##############
    if (dt < 0.000001):
        dt = 0.000001
    d_control = round((kd_control * ((error - error_prev)/dt)),2)

    ######### p + i + d control###############
    pid_control = p_control + i_control + d_control
    
    
    ###########saturation######################
    if (pid_control > saturation):
        pid_control = saturation
        i_windup = i_control
    elif(pid_control < 0):
        pid_control = 0 
    else:
        pid_control = pid_control
        i_windup = saturation
    
    
    ##########send pid value to microcontroller###########
    if (motor == "ON"):
        pid_control = pid_control        
        
        with open(filename, 'a') as csvfile:
            csvwriter = csv.writer(csvfile)
            rows = [ [str(str(waktu.hour) + str(":") + str(waktu.minute)+ str(":") + str(waktu.second))
                      ,str(setpoint),str(sensor),str(sensor_filtered),str(error) , str(p_control), str(i_control),str(d_control), str(motor_command)]]
            csvwriter.writerows(rows)
        
        with open(filename_buffer, 'a') as csvfile:
            csvwriter = csv.writer(csvfile)
            time_n = time.time() - time_n_prev
            rows = [ [str(str(waktu.hour) + str(":") + str(waktu.minute)+ str(":") + str(waktu.second))
                      ,str(setpoint),str(sensor),str(sensor_filtered),str(error) , str(p_control), str(i_control),str(d_control), str(motor_command)]]
            csvwriter.writerows(rows)
            
            
    if (motor == "OFF"):
        pid_control = 0
        i_control = 0
        time_n_prev = time.time()
        
        
    if (mode == "PID"):        
        motor_speed = pid_control + offset
        motor_command = pid_control
    if (mode == "STEP"):
        motor_speed = int(step_level) + offset
        motor_command = int(step_level)
    
    serial_send_time = time.time() - serial_send_time_prev
    if (serial_send_time > 0.5):
        ser.write(str(motor_speed).encode())
        serial_send_time_prev = time.time()
        
    
    
        print(str(sensor) + str(" p ") +str(round(p_control,1)) + str(" | i : ")+str(i_control) + str(" | d : ")+str(d_control)
          + str(" dt : ")+str(dt) + str(" pid : ")+str(int(motor_command)) + str(" motor: ") + str(motor_speed) )
    
    
    dt_prev = time.time()
    
    error_prev = error
    sensor_prev = sensor

if __name__ == '__main__':
    
    
    app = QApplication(sys.argv)
    QtQml.qmlRegisterType(RadialBar, "SDK", 1,0, "RadialBar")
   # app.setWindowIcon(QIcon("garuda.png"))
    timer = QTimer()
    timer.timeout.connect(timerEvent)
    timer.start(100) ##Update screen every 10 miliseconds
    w = table()
    
    t1 = threading.Thread(target=serial_read, args=(10,))
    t1.start()
    
    app.setWindowIcon(QIcon("logo ardumeka.png"))
    sys.exit(app.exec_())    