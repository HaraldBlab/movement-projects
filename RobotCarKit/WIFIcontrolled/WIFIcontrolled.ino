/*  
 * Rui Santos & Sara Santos - Random Nerd Tutorials
 * https://RandomNerdTutorials.com/esp32-wi-fi-car-robot-arduino/
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files.
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * Additions:
 * Use motor_functions.h
 * Set ESP32 as soft AP
 *
 * Board: ESP32 Dev Module
 * Port: COM8
*/

#include <WiFi.h>
#include <WebServer.h>
#include "motor_functions.h"

// Define credentials for the access point
const char* ssid     = "RobotCarKit";
const char* password = NULL;

// Create an instance of the WebServer on port 80
WebServer server(80);

String valueString = String(0);

void handleRoot() {
  const char html[] PROGMEM = R"rawliteral(
  <!DOCTYPE HTML><html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="data:,">
    <style>
      html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center; }
      .button { -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; background-color: #4CAF50; border: none; color: white; padding: 12px 28px; text-decoration: none; font-size: 26px; margin: 1px; cursor: pointer; }
      .button2 {background-color: #555555;}
    </style>
    <script>
      function moveForward() { fetch('/forward'); }
      function moveLeft() { fetch('/left'); }
      function stopRobot() { fetch('/stop'); }
      function moveRight() { fetch('/right'); }
      function moveReverse() { fetch('/reverse'); }

      function updateMotorSpeed(pos) {
        document.getElementById('motorSpeed').innerHTML = pos;
        fetch(`/speed?value=${pos}`);
      }
    </script>
  </head>
  <body>
    <h1>ESP32 Motor Control</h1>
    <p><button class="button" onclick="moveForward()">FORWARD</button></p>
    <div style="clear: both;">
      <p>
        <button class="button" onclick="moveLeft()">LEFT</button>
        <button class="button button2" onclick="stopRobot()">STOP</button>
        <button class="button" onclick="moveRight()">RIGHT</button>
      </p>
    </div>
    <p><button class="button" onclick="moveReverse()">REVERSE</button></p>
    <p>Motor Speed: <span id="motorSpeed">0</span></p>
    <input type="range" min="0" max="100" step="25" id="motorSlider" oninput="updateMotorSpeed(this.value)" value="0"/>
  </body>
  </html>)rawliteral";
  server.send(200, "text/html", html);
}

void handleForward() {
  Serial.println("Forward");
  advance();
  server.send(200);
}

void handleLeft() {
  Serial.println("Left");
  turnL();
  server.send(200);
}

void handleStop() {
  Serial.println("Stop");
  stopp();
  server.send(200);
}

void handleRight() {
  Serial.println("Right");
  turnR();
  server.send(200);
}

void handleReverse() {
  Serial.println("Reverse");
  back();
  server.send(200);
}

void handleSpeed() {
  if (server.hasArg("value")) {
    valueString = server.arg("value");
    int value = valueString.toInt();
    set_speed(value);
    Serial.println("Motor speed set to " + String(value));
  }
  server.send(200);
}

void setup() {
  Serial.begin(115200);

  M_Control_IO_config();

  // Connect to Wi-Fi
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.softAP(ssid, password);
  // Print soft access point IP address and start web server
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.softAPIP());
  server.begin();

  // Define routes
  server.on("/", handleRoot);
  server.on("/forward", handleForward);
  server.on("/left", handleLeft);
  server.on("/stop", handleStop);
  server.on("/right", handleRight);
  server.on("/reverse", handleReverse);
  server.on("/speed", handleSpeed);

  // Start the server
  server.begin();
}

void loop() {
  server.handleClient();
}
