import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import SDK 1.0
import QtCharts 2.1





Rectangle {
	id: root
	visible: true
	width: 1400
	height: 880
	color:"#8479e2"
	property bool fullscreen: false
	
	Image{
          id: appbackground
		  width : width.root
		  height : height.root
          x:0
          y:0         
          source:"ardumeka_background.png"
	}
	


	Image{
          id: logo
		  width :150
		  height : 150
          x:700
          y:0         
          source:"logo ardumeka.jpg"
	}
	
	Text {
					id : connection_type
					x : 200
					y : 65
					
					text: "MQTT"
					font.family: "Helvetica"
					font.pointSize: 14
					color: "white"
				}
	
	
Button {
		id: bt00
		x :20
		y :510
		text: "ON"
		
		onClicked:{
			if(bt00.text == "ON"){
				table.motor("ON")
				text = "OFF";
				//transient_analyzer.visible = true
				clear_buffer.visible = false
				bt_stepresponse.visible = true
			}else
				if(bt00.text == "OFF"){
					table.motor("OFF")
					text = "ON";
					//transient_analyzer.visible = false
					clear_buffer.visible = true
					bt_stepresponse.visible = false
				}
		}
		palette { 
		button: "white"
		buttonText: "black"		}
		
	}


Button {
		id: bt_stepresponse
		x :20
		y :600
		text: "STEP RESPONSE"
		visible : false
		onClicked:{
			if(bt_stepresponse.text == "STEP RESPONSE"){
				table.mode("STEP")
				text = "DONE";
				
			}else
				if(bt_stepresponse.text == "DONE"){
					table.mode("PID")
					text = "STEP RESPONSE";
					//transient_analyzer.visible = false
					//clear_buffer.visible = true
				}
		}
		palette { 
		button: "white"
		buttonText: "black"		}
		
	}

/*
Button {
		id: transient_analyzer
		x :350
		y :510
		text: "TRANSIENT ANALYZER"
		visible:false
		onClicked:{
			table.analysis("yes")
			}
		palette { 
		button: "white"
		buttonText: "black"		
		}	
		
	}
	
*/
	
Button {
		id: setting
		x :200
		y :510
		text: "SETTING"
		//visible:false
		onClicked:{
			//table.analysis("yes")
			setting_page.visible = true
			}
		palette { 
		button: "white"
		buttonText: "black"		
		}	
		
	}
	
	
	
	
	
	
Button {
		id: clear_buffer
		x :350
		y :510
		visible : false
		text: "clear buffer"
		onClicked:{
			table.clear_buffer("yes")
			}
		palette { 
		button: "white"
		buttonText: "black"		
		}	
		
	}


	
	Rectangle {
	id: radialbox
	x: 60
	y: 93
	visible: true
	width: 146
	height: 144
	color:"#8479e2"
	
	Image{
          id: logofan
          x:50
          y:60
          width: 100
          height: 100             
          source:"fanpict.png"
		  visible : false
	}
	
	
	
	
	
	
	Text {
					id:text_val
					y : 50
					anchors.horizontalCenter: parent.horizontalCenter
					text: slider1.value
					font.family: "Helvetica"
					font.pointSize: 25
					color: "white"
				}
	
	RadialBar {
				
	        	id : radial1
	            anchors.horizontalCenter: parent.horizontalCenter
	            anchors.bottom: parent.bottom
	            width: parent.width / 1.1
	            height: width - (0.00000000001)
	            penStyle: Qt.RoundCap
	            progressColor: "blue"
	            foregroundColor: "white"
	            dialWidth: 24

				
	            minValue: 0
	            maxValue: 1500
	            value: slider1.value
	            
	            textFont 
	            {	
					
	                family: "Times New Roman"
	                italic: false
	                pointSize: 14
	            }
                textColor: "white"
	            
				
				
	        }
	
	
	}
	
	
	Rectangle {
	x:529
	y:93
	id: radialbox2
	visible: true
	width: 144
	height: 144
	color:"#8479e2"
	
	
	
	
	
	Text {
					id:text_val2
					y : 50
					anchors.horizontalCenter: parent.horizontalCenter
					text:"0" 
					font.family: "Helvetica"
					font.pointSize: 25
					color: "white"
				}
	
	RadialBar {
				
	        	id : radial2
	            anchors.horizontalCenter: parent.horizontalCenter
	            anchors.bottom: parent.bottom
	            width: parent.width / 1.1
	            height: width - (0.00000000001)
	            penStyle: Qt.RoundCap
	            progressColor: "blue"
	            foregroundColor: "white"
	            dialWidth: 24

				
	            minValue: 0
	            maxValue: 1000
	           // value: text_val2
	            
	            textFont 
	            {	
					
	                family: "Times New Roman"
	                italic: false
	                pointSize: 14
	            }

	            textColor: "black"
				
				
	        }
	
		Image{
          id: electric
          x:50
          y:60
          width: 100
          height: 100             
          source:"listrikpict.png"
		  visible : false
	}
	
	
	}
	
	
	
	Rectangle{
			x: 0
			y: 320
			id : rectslider
			color : "white"
			width : 440
			height : 130
			anchors.leftMargin : 237.5
			anchors.bottomMargin : 50
			visible : true
			
			Text {
					id:text_p
					//anchors.horizontalCenter: parent.horizontalCenter
					x:5
					y:10
					text: "Set Point  :"
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
			
			
			Slider {
				id: slider1
				x:100
				y:10
				height: 20
				width: 275
				//value: 80
				to: 1500
				stepSize: 1
				visible: true
				onValueChanged: {
				table.setpoint(value)
		
		}
		Text {
					id:text_proportional
					x:-95
					y:30
					text: "P control  :"
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
		
		
		Slider {
				id: slider2
				//x:100
				y:30
				height: 20
				width: 275
				//value: 80
				to: 0.3
				stepSize: 0.0001
				visible: true
				
				onValueChanged: {
				table.setP_control(value)
		
		}
		
				
		
	}
	
	Text {
					id:kp_val
					x:275
					y:30
					text: slider2.value.toFixed(4)
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
	
	
	
	
	Text {
					id:integral
					x:-95
					y:60
					text: "I control   :"
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
	
	
	
	Slider {
				id: slider3
				//x:100
				y:60
				height: 20
				width: 275
				//value: 80
				to: 0.2
				stepSize: 0.0001
				visible: true
				onValueChanged: {
				table.setI_control(value)
		
		}
		
	}
	
	Text {
					id:ki_val
					x:275
					y:60
					text: slider3.value.toFixed(4)
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
	
	Text {
					id:derivative
					x:-95
					y:90
					text: "D control  :"
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
				
	
	
	
	Slider {
				id: slider4
				//x:100
				y:90
				height: 20
				width: 275
				//value: 80
				to: 0.03
				stepSize: 0.0001
				visible: true
				
				onValueChanged: {
				table.setD_control(value)
		
		}
		
	}
	
	Text {
					id:kd_val
					x:275
					y:90
					text: slider4.value.toFixed(4)
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
	
	
	Rectangle {
            id: chart1
            x: 350
            y: -20
            width: 400
            height: 230
            visible: true
            color: "black"
			
            ChartView {
                id: cv
                height: parent.height
                property double valueCH3: 0
                property double valueCH2: 0
                //theme: ChartView.ChartThemeDark
                property double valueCH4: 0
                title: ""
                legend.visible: true
                property double startTIME: 1
                property int timcnt: 0
                property double periodGRAPH: 1000 //30
                property double intervalTM: 10000 //200
                anchors.fill: parent
				backgroundColor:"white"
                ValueAxis {
                    id: yAxis
                    max: 2500
                    min: 0
                    //labelFormat: "%d"
                    tickCount: 1
                }
				
				
				ValueAxis {
                    id: yAxis1
					
                    max: 250
                    min: 0
                    //labelFormat: "%d"
                    tickCount: 1
                }
				
				
				
				LineSeries {
					
                    id: lines1
                    name: "SETPOINT"
                    width: 5
                    color: "red"
                    axisX: DateTimeAxis {
                        id: eje
                        //format: "HH:mm:ss.z"
                        visible:false
                    }
                    axisY: yAxis
                }
				
				
                LineSeries {
                    id: lines2
                    name: "SENSOR"
                    width: 5
                    color: "black"
                    axisX: eje
                    axisY: yAxis
					
                }
				
                property double valueCH1: 0
                antialiasing: true
            }

            Timer {
                id: tm
                repeat: true
				interval : 100
                running: true
                onTriggered: {
                        cv.timcnt = cv.timcnt + 1
                        //cv1.timcnt = cv1.timcnt + 1
                      
                        cv.valueCH1 = parseFloat(slider1.value)
                        cv.valueCH2 = parseFloat(gauge2.value)
                        cv.valueCH3 = 70
                        cv.valueCH4 = 100


                        lines1.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv.valueCH1)
                        lines2.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv.valueCH2)
                        //lines3.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv.valueCH3)
                        //lines4.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv.valueCH4)

                        //lines1.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH1)
                        //lines2.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH2)
                        //lines3.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH3)
                        //lines4.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH4)

                        lines1.axisX.min = cv.timcnt < cv.periodGRAPH ? new Date(cv.startTIME) : new Date(cv.startTIME  - cv.periodGRAPH*1000 + cv.timcnt*1000)
                        lines1.axisX.max = cv.timcnt < cv.periodGRAPH ? new Date(cv.startTIME  + cv.periodGRAPH*1000) : new Date(cv.startTIME   + cv.timcnt*1000)

                        lines1.axisX.min = new Date(cv.startTIME-cv.periodGRAPH*1000 + cv.timcnt*500)
                        lines1.axisX.max = new Date(cv.startTIME + cv.timcnt*500)

                        lines1.axisX.min = new Date (cv.startTIME-cv.periodGRAPH*1000 + cv.timcnt*cv.intervalTM)  
                        lines1.axisX.max = new Date (cv.startTIME + cv.timcnt*cv.intervalTM)  


                        lines2.axisX.min = new Date(cv.startTIME-cv.periodGRAPH*1000 + cv.timcnt*cv.intervalTM)
                        lines2.axisX.max = new Date(cv.startTIME + cv.timcnt*cv.intervalTM)
                    }
            }
        }
	
	
	
	}
	}
	
	
	Rectangle {
		id:rect2
		x: 295
		y: 93
		width: 144
		height: 144
		color: "#8479e2"

		CircularGauge {
			id: gauge2
			width: rect2.width
			height: rect2.height
			value: 0
			anchors.centerIn: parent
			minimumValue : 0
			maximumValue : 2000
			//tickmarkStepSize : 1
			style: CircularGaugeStyle {
				id: style
				labelStepSize: Math.floor((gauge2.maximumValue - gauge2.minimumValue)/10)
				
				
				function degreesToRadians(degrees) {
					return degrees * (Math.PI / 180);
				}

				background: Canvas {
					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();
						ctx.beginPath();
						ctx.strokeStyle = "#e34c22";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(80) - 90), degreesToRadians(valueToAngle(100) - 90));
						ctx.stroke();
					}
				}

				tickmark: Rectangle {
					visible: styleData.value < 1600 || styleData.value % 10 == 0
					implicitWidth: outerRadius * 0.02
					antialiasing: true
					implicitHeight: outerRadius * 0.06
					color: styleData.value >= 1600 ? "white" : "white"
				}

				minorTickmark: Rectangle {
					visible: styleData.value < 1600
					implicitWidth: outerRadius * 0.01
					antialiasing: true
					implicitHeight: outerRadius * 0.03
					color: "#e5e5e5"
				}

				tickmarkLabel:  Text {
					font.pixelSize: Math.max(5, outerRadius * 0.14)
					text: Math.floor(styleData.value)
					color: styleData.value >= 1600 ? "black" : "black"
					antialiasing: true
				}

				needle: Rectangle {
					y: outerRadius * 0.15
					implicitWidth: outerRadius * 0.03
					implicitHeight: outerRadius * 0.9
					antialiasing: false
					color: "white"
				}

				foreground: Item {
					Rectangle {
						width: outerRadius * 0.2
						height: width
						radius: width / 2
						color: "black"
						anchors.centerIn: parent
					}
				}
				
				
			}
			
			
			
			
			Rectangle {
				id:rectsg2
				anchors.horizontalCenter: parent.horizontalCenter
				y: 120
				width: 40
				height: 20
				color: "#8479e2"
				Text {
					id:textgauge2
					anchors.horizontalCenter: parent.horizontalCenter
					text: Math.floor(gauge2.value)
					font.family: "Times New Roman"
					font.pointSize: 14
					color: "black"
				}
			}
			
			
		
		
		}
	
	
	Rectangle{
		id : setting_page
		x : 100
		y : -100
		width : 500
		height : 500
		color : "grey"
		visible : false
		
		
		Button {
		id : close_setting
		x:300
		y:0
		text : "close"
		onClicked:{
		setting_page.visible = false
		}
		
		}
	
	
		Button {
		id : apply
		x:300
		y:450
		text : "apply"
		onClicked:{
			slider1.from = sp_min.text
			slider1.to = sp_max.text
			radial1.minValue = sp_min.text
			radial1.maxValue = sp_max.text
			
			
			slider2.from = kp_min.text
			slider2.to = kp_max.text
			
			slider3.from = ki_min.text
			slider3.to = ki_max.text
			
			slider4.from = kd_min.text
			slider4.to = kd_max.text
			
			gauge2.minimumValue = sensor_min.text
			gauge2.maximumValue = sensor_max.text
		
			
			yAxis.min = graph_min.text
			yAxis.max = graph_max.text
		
			radial2.maxValue = control_signal_max.text
			table.saturation(control_signal_max.text)
			steplevel.to = control_signal_max.text
			
			
			table.offset(offset_val.text)
		
			table.filter_weight(filter_weight_val.text)
		}
		
		
		
		}
	
		Text{
		x:0
		y:50
		text : "STEP LEVEL :"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
	
		Slider {
				id: steplevel
				x:120
				y:50
				height: 20
				width: 200
				//value: 80
				to: 1000
				stepSize: 1
				visible: true
				onValueChanged: {
				table.step_level(value)
		
		}
		
		Text{
		x:200
		y:20
		text : steplevel.value
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
	
	
	
		}
		
		
		Text{
		x:0
		y:100
		text : "sp min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : sp_min
		x:80
		y:100
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		Text{
		x:200
		y:100
		text : "sp max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : sp_max
		x:270
		y:100
		text : "1500"
		font.family: "Helvetica"
		font.pointSize: 14
		}


		
		Text{
		x:0
		y:150
		text : "kp min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : kp_min
		x:80
		y:150
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		Text{
		x:200
		y:150
		text : "kp max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : kp_max
		x:270
		y:150
		text : "0.3"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		
		
		
		Text{
		x:0
		y:180
		text : "ki min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : ki_min
		x:80
		y:180
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		Text{
		x:200
		y:180
		text : "ki max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : ki_max
		x:270
		y:180
		text : "0.3"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		
		
		
		
		Text{
		x:0
		y:215
		text : "kd min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		TextInput{
		id : kd_min
		x:80
		y:215
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		Text{
		x:200
		y:215
		text : "kd max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : kd_max
		x:270
		y:215
		text : "0.3"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		
			
		Text{
		x:0
		y:240
		text : "sensor min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : sensor_min
		x:110
		y:240
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		Text{
		x:200
		y:240
		text : "sensor max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : sensor_max
		x:310
		y:240
		text : "2000"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		
		
		
		Text{
		x:0
		y:275
		text : "control signal min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		Text{
		x:160
		y:275
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		Text{
		x:220
		y:275
		text : "control signal max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : control_signal_max
		x:400
		y:275
		text : "1000"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
			
		Text{
		x:0
		y:300
		text : "graph min:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : graph_min
		x:100
		y:300
		text : "0"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		Text{
		x:150
		y:300
		text : "graph max:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : graph_max
		x:270
		y:300
		text : "2500"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		Text{
		x:0
		y:330
		text : "time sampling range:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		Text{
		x:0
		y:370
		text : "offset:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : offset_val
		x:75
		y:370
		text : "1000"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		
		Text{
		x:0
		y:400
		text : "filter weight:"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
		TextInput{
		id : filter_weight_val
		x:120
		y:400
		text : "0.9"
		font.family: "Helvetica"
		font.pointSize: 14
		}
		
	
	}
	
	
	}
	
	
	
		function sensor_val_read(text) {
		gauge2.value = text
		}
		
		
		function power_val_read(text) {
		text_val2.text = text
		radial2.value = text
		}
	
		function connection_type_val_read(text) {
		connection_type.text = text
		}
	
	
}