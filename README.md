# Ray-Tracing Simulation

<!--About the project-->
## About the project

A 3D renderer that draws pre-placed 3D objects (spheres and triangles - and thus all possible shapes) in a window: 
A ray-tracing simulation that handles metallic, transparent, and "diffuse" materials.

Here is an example of a render:
![Render example][render-example-url]

## Getting started

Clone or download repository on your local machine. Open `ray_processing_index.pde` in Processing.

Execute the code in Processing. When the render is complete, it will save the frame in `render.png`, as well as display in a window

## How to use
It is **very** easy to customize this renderer. Follow these steps to do so:

### Changing the render size
To change the render size, just change the ´size(x, y)´ parameters in ´setup()´
```
void setup() {
  size(1280, 720); //Creates a render of size 1280x720
  ...
}
```

### Changing Scene-settings
To change Scene-settings access the static class `Scene` and chnage the values of its fields:

```
public static class Scene {
  public static Camera camera;
  
  public static color sunColor;                                               //Color of the sun
  public static color horizonColor;                                           //Color of the background
  public static PVector sunDirection = new PVector(-10, 0, -10).normalize();  //Direction of the sun
  public static float sunBrightness = 0.33;                                   //Brightness of the sun
  public static float hardShadows = 0.1;                                      //How hard the shadows are computed
}
```

As you can see, the Scene needs to be assigned a Camera that will be used for the render. Create camera with:
```
Camera(PVector position, PVector rotation, float FOV)
```

Here is an example of a scene setup in `setup()`:
```
void setup() {
  ...
  //Setup Scene
  Scene.camera = new Camera(new PVector(0, 0, 0), new PVector(1, 0, 0), 75); //Creates a camera at (0,0,0) with 75deg FOV
  Scene.sunColor = color(255, 255, 255);  
  Scene.horizonColor = color(100, 100, 100); 
  Scene.sunDirection = new PVector(-10, 0, -10).normalize();  
  Scene.hardShadows = 0.1;
  ...
}
```

### Setup objects in the scene
To add objects in the scene use `createGameObject(GameObject gameObject)`. There are 5 GameObjects you can add:

```
SphereObject(PVector position, float radius, Material material)

TriangleObject(PVector position, PVector[3] points, Material material)

Cuboid(PVector position, float[3] dimensions, Material material)

Plane(PVector position, float[2] dimensions, Material material)

CustomGameObject(PVector position, Shape[] shape, Material material)
```

All GameObject require a position and a material. A material defines how the gameobject is rendered: 
It dictates its color, its metaliccness, its transparency, etc. They all interact with light differently.
There are 4 kinds of materials you can instantiate:

```
DiffuseMaterial(Color color, float roughness)

ReflectiveMaterial(Color color)

TransparentMaterial(Color color, float refractionIndex, float reflectiveIndex)

EmitterMaterial(Color color)
```

If you wish to create a custom gameObject with `CustomGameObject(...)`, you need to pass an array of `Shape`s.
GameObjets are made of shapes. Shapes are the most broken down an object can be.
There 2 types of shapes you can instantiate:

```
Triangle(Pvector position, PVector[3] points, boolean isDoubledFaced, boolean flipNormals)

Sphere(PVector origin, float radius)
```


## Specification
This simulation is very slow as **does not** incorporate threading or any kind of parrallell programming.




[render-example-url]: https://github.com/FireGreeks/ray-tracing-processing/blob/master/render.png
