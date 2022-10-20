import math

# map an angle in radians (0..2*pi) to (0..255)
def mapa(angle):
  return int(256*angle/(2*math.pi))

# map a sin value (-1..1) to (0..255)
def maps(sin):
 return int(sin*128+128)

# map a (servo) position (0..360) to (0..255)
def mapp(pos):
  return int(256*pos/180)

def calcp(sin):
  x = 128*(1 + sin)
  return int((256 + x) / 3)

def printit(a, b, c, lastvalue, newline):
  if lastvalue == False:
    if (newline == True):
      endit = " ),\n"
    else:
      endit = " ), "
  else:
    endit = " )\n"
  print("  (", end=" ")
  # TODO: no need to limit range
  print(a%256, b%256, c%256, sep=", ", end=endit)
  print

def stimulus(what, steps=1):
  if steps > 256:
    steps = 256
  for i in range (0, steps): 
    # angle = i/36
    angle = i*math.pi/128
    angle1 = angle
    angle2 = angle + 2*math.pi/3
    angle3 = angle + 4*math.pi/3
    sin1 = math.sin(angle1)
    sin2 = math.sin(angle2)
    sin3 = math.sin(angle3)
    pos1 = 90 + 30*sin1
    pos2 = 90 + 30*sin2
    pos3 = 90 + 30*sin3
    if what == "a":
      printit(mapa(angle1), mapa(angle2), mapa(angle3), i==steps-1, i%4==3)
    elif what == 's':
      printit(maps(sin1), maps(sin2), maps(sin3), i==steps-1, i%4==3)
    elif what == 'p':
      printit(mapp(pos1), mapp(pos2), mapp(pos3), i==steps-1, i%4==3)
    else:
      # calculation formula
      # x2 = 128*(1 + sin2)
      # y2 = 30 * (x2 / 128 - 1)
      # y2 = 30 * x2 / 128 - 30 
      # y2 = 30 * x2 / 128# - 30 
      # z2 = 90 + y2
      # z2 = 90 + y2 - 30
      # z2 = 60 + y2
      # z2 = 60 + 30 * x2 / 128
      # z2 = (60*128 + 30 * x2) / 128
      # z2 = 30*(2*128 + x2) / 128
      # z2 = 30*(256 + x2) / 128
      # p2 = int(256*z2/180)
      # p2 = int(256*30*(256 + x2) / 128/180)
      # p2 = int(2*30*(256 + x2) / 180)
      # p2 = int((256 + x2) / 3)
      p1 = calcp(sin1)
      p2 = calcp(sin2)
      p3 = calcp(sin3)
      printit(p1, p2, p3, i==steps, i%4==3)


def stimulus_array(what, variable, steps):
  print("signal " + variable + " : stimulus_data_array := (")
  stimulus(what, steps=steps)
  print(");")

def stimulus_data_array(steps):
  print("type stimulus_data_array is array(1 to " + str(steps) + ") of stimulus_data;") 

steps = 256

stimulus_data_array(steps);
stimulus_array("a", "test_angle", steps)
stimulus_array("s", "test_sin", steps)
stimulus_array("p", "test_position", steps)
#stimulus_array("c", "calc_position", steps)
