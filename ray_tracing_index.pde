
//Function is called once at the start
void setup() {
  //Canvas setup
  size(640, 360);
  background(0);
  noLoop();
  
  stroke(255);
  textSize(44);
  textAlign(CENTER);
  text("Rendering... Please wait", width/2, height/2);
    
  //Setup Scene
  Scene.camera = new Camera(new PVector(0, 0, 0), new PVector(1, 0, 0), 75);
  Scene.sunColor = color(255, 255, 255);
  Scene.horizonColor = color(100, 100, 100);
  Scene.sunDirection = new PVector(-10, 0, -10).normalize();
  Scene.hardShadows = 0.1;
  
  
  //Setup of objects in scene
  createGameObject(new SphereObject(new PVector(4,-1,0), 1, 
    new DiffuseMaterial(color(255, 255, 48), 1)));
    
  createGameObject(new SphereObject(new PVector(10,0,-2), 5, 
    new ReflectiveMaterial(color(255, 0, 48))));
   
  createGameObject(new Cuboid(new PVector(10, 4, -3), new float[] {3, 3, 3}, 
    new DiffuseMaterial(color(0, 255, 0), 1)));
    
  createGameObject(new Plane(new PVector(7, 0, 2), new float[] {20, 12},
    new DiffuseMaterial(color(255), 1)));
      
  createGameObject(new TriangleObject(new PVector(7.5,5,-3), new PVector[] {new PVector(0,0,-2), new PVector(0,-2,2), new PVector(0,2,2)},
    new TransparentMaterial(color(0, 0, 255), 1.3, 0.75)));
  
}

//Function is called once every frame (except for noLoop())
void draw() {
  
  //Loop every pixel on screen
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      frag(new Pixel(j, i));
    }
  }
  
  //Draw render to image file
  saveFrame("render.png");
}
