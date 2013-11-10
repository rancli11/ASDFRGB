int mode = 1;

//MODE:
//0 -> black
//1 -> bright
//2 -> white
//b(16777216)

PImage img;
PImage Red;
PImage Blue;
PImage Green;
PImage img2;
String imgFileName = "3";
String fileType = "png";

int loops = 1;
int f;

int blackValue = -16000000;
int brigthnessValue = 60;
int whiteValue = -13000000;

int row = 0;
int column = 0;

boolean saved = false;

void setup() {
  selectInput("Select a file to process:", "fileSelected");
  frame.setResizable(true);
  img = loadImage(imgFileName+"."+fileType);
  Red = loadImage(imgFileName+"."+fileType);
  Blue = loadImage(imgFileName+"."+fileType);
  Green = loadImage(imgFileName+"."+fileType);
  img2 = loadImage(imgFileName+"."+fileType);
  size(img.width, img.height);
  image(img, 0, 0);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
  img = loadImage(selection.getAbsolutePath());
  Red = loadImage(selection.getAbsolutePath());
  Blue = loadImage(selection.getAbsolutePath());
  Green = loadImage(selection.getAbsolutePath());
  img2 = loadImage(selection.getAbsolutePath());
  frame.setSize(img.width+20,img.height+30);
  
}


void draw() {
  //img.loadPixels();
  img.copy(img2, 0,0,img2.width,img2.height,0,0,img.width,img.height);
  Red.copy(img2, 0,0,img2.width,img2.height,0,0,img.width,img.height);
  Green.copy(img2, 0,0,img2.width,img2.height,0,0,img.width,img.height);
  Blue.copy(img2, 0,0,img2.width,img2.height,0,0,img.width,img.height);
  brigthnessValue = mouseX;
  while(column < img.width-1) {
    img.loadPixels(); 
    sortRedColumn();
    sortGreenColumn();
    sortBlueColumn();
    combineRGBColumn();
    column++;
    img.updatePixels();
  }
  
  while(row < img.height-1) {
    img.loadPixels(); 
    sortRedRow();
    sortGreenRow();
    sortBlueRow();
    combineRGBRow();
    row++;
    img.updatePixels();
  }
  row = 0;
  column = 0;
  //img.updatePixels();
  image(img,0,0);
  /*if(!saved && frameCount >= loops) {
    saveFrame(imgFileName+"_"+mode+".png");
    saved = true;
    println("DONE"+frameCount);
    //System.exit(0);
    
  }*/
}

void combineRGBRow() {
  int y = row;
  for (int x = 0; x < img.width; x++) {
    img.pixels[(x + y*img.width)%(img.height*img.width)] = color(red(Red.pixels[(x + y*Red.width)%(Red.height*Red.width)]),green(Green.pixels[(x + y*Green.width)%(Green.height*Green.width)]),blue(Blue.pixels[(x + y*Blue.width)%(Blue.height*Blue.width)]));
  }
}
void combineRGBColumn() {
  int x = column;
  for (int y = 0; y < img.height; y++) {
    img.pixels[(y + x*img.height)%(img.height*img.width)] = color(red(Red.pixels[(y + x*Red.height)%(Red.height*Red.width)]),green(Green.pixels[(y + x*Green.height)%(Green.height*Green.width)]),blue(Blue.pixels[(y + x*Blue.height)%(Blue.height*Blue.width)]));
  }
}
void sortRedRow() {
  int x = 0;
  int y = row;
  int xend = 0;
  
  while(xend < img.width-1) {
    switch(mode) {
      case 0:
        x = getFirstDarkRedX(x, y);
        xend = getNextBrightRedX(x, y);
        break;
      case 1:
        x = getFirstBrightRedX(x, y);
        xend = getNextDarkRedX(x, y);
        break;
      /*case 2:
        x = getFirstNotWhiteX(x, y);
        xend = getNextWhiteX(x, y);
        break;*/
      default:
        break;
    }
    
    if(x < 0) break;
    
    int sortLength = xend-x;
    
    float[] unsortedRed = new float[sortLength];
    float[] sortedRed = new float[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsortedRed[i] = red(Red.pixels[(x + i + y * Red.width)%(Red.width*Red.height)]);
    }
    
    sortedRed = sort(unsortedRed);
    
    for(int i=0; i<sortLength; i++) {
      Red.pixels[(x + i + y * Red.width)%(Red.width*Red.height)] = color(sortedRed[i],0,0);      
    }
    
    x = xend+1;
  }
}
void sortGreenRow() {
  int x = 0;
  int y = row;
  int xend = 0;
  
  while(xend < img.width-1) {
    switch(mode) {
      case 0:
        x = getFirstDarkGreenX(x, y);
        xend = getNextBrightGreenX(x, y);
        break;
      case 1:
        x = getFirstBrightGreenX(x, y);
        xend = getNextDarkGreenX(x, y);
        break;
      /*case 2:
        x = getFirstNotWhiteX(x, y);
        xend = getNextWhiteX(x, y);
        break;*/
      default:
        break;
    }
    
    if(x < 0) break;
    
    int sortLength = xend-x;

    float[] unsortedGreen = new float[sortLength];
    float[] sortedGreen = new float[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsortedGreen[i] = green(Green.pixels[(x + i + y * Green.width)%(Green.width*Green.height)]);
    }
    
    sortedGreen = sort(unsortedGreen);
    
    for(int i=0; i<sortLength; i++) {
      Green.pixels[(x + i + y * Green.width)%(Green.width*Green.height)] = color(0,sortedGreen[i],0);      
    }
    
    x = xend+1;
  }
}
void sortBlueRow() {
  int x = 0;
  int y = row;
  int xend = 0;
  
  while(xend < img.width-1) {
    switch(mode) {
      case 0:
        x = getFirstDarkBlueX(x, y);
        xend = getNextBrightBlueX(x, y);
        break;
      case 1:
        x = getFirstBrightBlueX(x, y);
        xend = getNextDarkBlueX(x, y);
        break;
      /*case 2:
        x = getFirstNotWhiteX(x, y);
        xend = getNextWhiteX(x, y);
        break;*/
      default:
        break;
    }
    
    if(x < 0) break;
    
    int sortLength = xend-x;
    
    float[] unsortedBlue = new float[sortLength];
    float[] sortedBlue = new float[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsortedBlue[i] = blue(Blue.pixels[(x + i + y * Blue.width)%(Blue.width*Blue.height)]);
    }
    
    sortedBlue = sort(unsortedBlue);
    
    for(int i=0; i<sortLength; i++) {
      Blue.pixels[(x + i + y * Blue.width)%(Blue.width*Blue.height)] = color(0,0,sortedBlue[i]);      
    }
    
    x = xend+1;
  }
}

void sortRedColumn() {
  int x = column;
  int y = 0;
  int yend = 0;
  
  while(yend < img.height-1) {
    switch(mode) {
      case 0:
        y = getFirstDarkRedY(x, y);
        yend = getNextBrightRedY(x, y);
        break;
      case 1:
        y = getFirstBrightRedY(x, y);
        yend = getNextDarkRedY(x, y);
        break;
      /*case 2:
        y = getFirstNotWhiteY(x, y);
        yend = getNextWhiteY(x, y);
        break;*/
      default:
        break;
    }
    
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    float[] unsorted = new float[sortLength];
    float[] sorted = new float[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = red(Red.pixels[(x + (y+i) * Red.width)%(Red.width*Red.height)]);
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      Red.pixels[(x + (y+i) * Red.width)%(Red.width*Red.height)] = color(sorted[i],0,0);
    }
    
    y = yend+1;
  }
}
void sortGreenColumn() {
  int x = column;
  int y = 0;
  int yend = 0;
  
  while(yend < img.height-1) {
    switch(mode) {
      case 0:
        y = getFirstDarkGreenY(x, y);
        yend = getNextBrightGreenY(x, y);
        break;
      case 1:
        y = getFirstBrightGreenY(x, y);
        yend = getNextDarkGreenY(x, y);
        break;
      /*case 2:
        y = getFirstNotWhiteY(x, y);
        yend = getNextWhiteY(x, y);
        break;*/
      default:
        break;
    }
    
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    float[] unsorted = new float[sortLength];
    float[] sorted = new float[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = green(Green.pixels[(x + (y+i) * Green.width)%(Green.width*Green.height)]);
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      Green.pixels[(x + (y+i) * Green.width)%(Green.width*Green.height)] = color(0,sorted[i%sorted.length],0);
    }
    
    y = yend+1;
  }
}

void sortBlueColumn() {
  int x = column;
  int y = 0;
  int yend = 0;
  
  while(yend < img.height-1) {
    switch(mode) {
      case 0:
        y = getFirstDarkBlueY(x, y);
        yend = getNextBrightBlueY(x, y);
        break;
      case 1:
        y = getFirstBrightBlueY(x, y);
        yend = getNextDarkBlueY(x, y);
        break;
      /*case 2:
        y = getFirstNotWhiteY(x, y);
        yend = getNextWhiteY(x, y);
        break;*/
      default:
        break;
    }
    
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    float[] unsorted = new float[sortLength];
    float[] sorted = new float[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = blue(Blue.pixels[(x + (y+i) * Blue.width)%(Blue.width*Blue.height)]);
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      Blue.pixels[(x + (y+i) * Blue.width)%(Blue.width*Blue.height)] = color(0,0,sorted[i%sorted.length]);
    }
    
    y = yend+1;
  }
}

//BLACK
int getFirstNotBlackX(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) < blackValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}

int getNextBlackX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) > blackValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

//BRIGHTNESS
int getFirstBrightRedX(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}
int getFirstBrightGreenX(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}
int getFirstBrightBlueX(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}
int getFirstDarkRedX(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}
int getFirstDarkGreenX(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}
int getFirstDarkBlueX(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}

int getNextDarkRedX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  float c;
  while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}
int getNextDarkGreenX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  float c;
  while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}int getNextDarkBlueX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  float c;
  while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}
int getNextBrightRedX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  float c;
  while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}
int getNextBrightGreenX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  float c;
  while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}
int getNextBrightBlueX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  float c;
  while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

//WHITE
int getFirstNotWhiteX(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) > whiteValue) {
    x++;
    if(x >= img.width) return -1;
  }
  return x;
}

int getNextWhiteX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) < whiteValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}


//BLACK
int getFirstNotBlackY(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  if(y < img.height) {
    while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) < blackValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}

int getNextBlackY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  color c;
  if(y < img.height) {
    while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) > blackValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}

//BRIGHTNESS
int getFirstBrightRedY(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  if(y < img.height) {
    while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}
int getFirstBrightGreenY(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  if(y < img.height) {
    while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}
int getFirstBrightBlueY(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  if(y < img.height) {
    while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}
int getFirstDarkRedY(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  if(y < img.height) {
    while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}
int getFirstDarkGreenY(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  if(y < img.height) {
    while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}int getFirstDarkBlueY(int _x, int _y) {
  int x = _x;
  int y = _y;
  float c;
  if(y < img.height) {
    while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}

int getNextDarkRedY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  float c;
  if(y < img.height) {
    while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
int getNextDarkGreenY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  float c;
  if(y < img.height) {
    while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
int getNextDarkBlueY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  float c;
  if(y < img.height) {
    while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) > brigthnessValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
int getNextBrightRedY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  float c;
  if(y < img.height) {
    while(brightness(color(c = red(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
int getNextBrightGreenY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  float c;
  if(y < img.height) {
    while(brightness(color(c = green(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
int getNextBrightBlueY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  float c;
  if(y < img.height) {
    while(brightness(color(c = blue(img.pixels[(x + y * img.width)%(img.width*img.height)]))) < brigthnessValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}

//WHITE
int getFirstNotWhiteY(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  if(y < img.height) {
    while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) > whiteValue) {
      y++;
      if(y >= img.height) return -1;
    }
  }
  return y;
}

int getNextWhiteY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  color c;
  if(y < img.height) {
    while((c = img.pixels[(x + y * img.width)%(img.width*img.height)]) < whiteValue) {
      y++;
      if(y >= img.height) return img.height-1;
    }
  }
  return y-1;
}
void mousePressed() {
  if (mouseButton == LEFT) {//saveFrame("output-####.png");
    File dir = new File (sketchPath(""));
    String[] list = dir.list();
    if (list == null) {
      println("Folder does not exist or cannot be accessed.");
    } 
    f = list.length;
    String i = Integer.toString(f);
    img.save(i+".png");
  }
  if (mouseButton == RIGHT) {
    mode++;
    if (mode == 2)
    mode = 0;
  }
}
