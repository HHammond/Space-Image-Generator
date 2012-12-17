/*
This code recursively generates artwork designed to look like
images of space. The program was originally designed to generate
semi-realistic ink blots 

Created by Henry Hammond 2012
*/


ArrayList <node> nodes = new ArrayList();

//dot (star) radius
float rad = 1;
//initial distance from initial point
float initDistance = 500;
//factor at which each dot will be generated from it's parent
float dispersionFactor = 0.83;
//maximum nodes (stars) to be rendered
//this defines how long the program will run and with how much detail
int maxNodes = (int)pow(2,17);
//opacity of light and gas effect around stars
float shadowOpacity = 0.03;
//radius of shadow with respect to star's distance from parent
float shadowWidth = 0.5;
//factor at which stars shrink
float dotSizeFactor = 0.01;
//float dotSizeFactor = 0.025;


void setup() {
  size(1280, 720);
  background(255);
  println("Max Nodes: "+maxNodes);  
}

//method to generate and process image to a graphics context
public void processImage(PGraphics p){
  p.smooth();
  
  //this loop iterates through more stars
  int number = 1;
  for (int j=0;j<number;j++) {
    //generate graphcis
    println("Processing ink blot "+j);
    nodes = new ArrayList();
    node a = new node(width/2, height/2, initDistance,null);
    nodes.add(a);
    p.background(0);
    
    p.ellipseMode(CENTER);
    p.noFill();
    
    //begin the spawning process
    p.beginShape();
    p.vertex(nodes.get(0).x,nodes.get(0).y);
    while (nodes.size () <= maxNodes) {
      for (int i=0;i<nodes.size() && nodes.size()<= maxNodes;i++) {
        if (nodes.get(i).edgeDistance != 0) {
          nodes.add(nodes.get(i).createChild());
        }
      }
    }
    p.endShape();

    //finally draw objects to the context
    p.noStroke();
    for (int i=0;i<nodes.size();i++) {
      nodes.get(i).draw(p);
      //    println(i);
    }
  }
}

//process graphics (old version, for saving ink blots directly to file)
public void processInks(int number) {
  
  smooth();
  
  for (int j=0;j<number;j++) {
    println("Processing ink blot "+j);
    nodes = new ArrayList();
    node a = new node(width/2, height/2, initDistance,null);
    nodes.add(a);
    background(0);
    
    ellipseMode(CENTER);
    noFill();
    
    beginShape();
    vertex(nodes.get(0).x,nodes.get(0).y);
    while (nodes.size () <= maxNodes) {
      for (int i=0;i<nodes.size() && nodes.size()<= maxNodes;i++) {
        if (nodes.get(i).edgeDistance != 0) {
          nodes.add(nodes.get(i).createChild());
        }
      }
    }
    endShape();

    
    noStroke();
    for (int i=0;i<nodes.size();i++) {
      nodes.get(i).draw();
      //    println(i);
    }

    //saveFrame("ink-"+j+".png");
  }
}

int c = 0;
void draw(){
  /*
  //PGraphics img = createGraphics(width,height,P2D);
  PGraphics2D img = new PGraphics2D();
  img.setParent(this);
  img.setPrimary(false);
  img.setSize(width, height);
  img.beginDraw();
  processImage(img);
  img.endDraw();
  img.save("IMG_"+c+++".png");
  image(img,0,0);
  */
  processInks(1);
}

//this class is the star or node
public class node {

  float edgeDistance;
  float x, y;
  node vertices;
  
  node parent;
  
  public node(float x, float y, float edgeDistance){
    this.x = x;
    this.y = y;
    if (edgeDistance < 1) {
      this.edgeDistance = 0;
    } 
    else {
      this.edgeDistance = edgeDistance;
    }
  }
  public node(float x, float y, float edgeDistance,node parent) {

    this.x = x;
    this.y = y;
    this.parent = parent;
    if (edgeDistance < 1) {
      this.edgeDistance = 0;
    } 
    else {
      this.edgeDistance = edgeDistance;
    }
  }
  

  public void draw(PGraphics p) {
    p.fill( random(150,255),random(150,255),random(150,255),1/sqrt(3.14159*random(0,150))*255); 
    p.ellipse(x, y, rad+dotSizeFactor*edgeDistance, rad+dotSizeFactor*edgeDistance);
    p.fill( random(150,255),random(150,255),random(150,255),random(100,255)*shadowOpacity); 
    p.ellipse(x, y, edgeDistance*shadowWidth, edgeDistance*shadowWidth);

    p.ellipse(x,y,0.33*edgeDistance*shadowWidth,0.33*edgeDistance*shadowWidth);
  }

  public void draw() {
    fill( random(150,255),random(150,255),random(150,255),1/sqrt(3.14159*random(0,150))*255); 
    ellipse(x, y, rad+dotSizeFactor*edgeDistance, rad+dotSizeFactor*edgeDistance);
    fill( random(150,255),random(150,255),random(150,255),random(100,255)*shadowOpacity); 
    ellipse(x, y, edgeDistance*shadowWidth, edgeDistance*shadowWidth);

    ellipse(x,y,0.33*edgeDistance*shadowWidth,0.33*edgeDistance*shadowWidth);
  }

  public node createChild() {
    node n = new node( x + random(edgeDistance)-edgeDistance/2, y + random(edgeDistance)-edgeDistance/2, edgeDistance*dispersionFactor,this);
    return n;
  }
}

