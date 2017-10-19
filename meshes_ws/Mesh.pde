
import java.util.*;

PShape shape;

class PolygonMesh{
  ArrayList<PVector> vertex;
  ArrayList<PShape> faces;

  public PolygonMesh(ArrayList<PVector> vertex, ArrayList<PShape> faces){
    this.vertex = vertex;
    this.faces = faces;
  }

  public void addVertex(PVector v){
    vertex.add(v);
  }

  public void addFace(PShape f){
    faces.add(f);
  }

}

class Mesh {
  // radius refers to the mesh 'bounding sphere' redius.
  // see: https://en.wikipedia.org/wiki/Bounding_sphere
  float radius = 200;

  //Face_Vertex
  HashMap<PVector, ArrayList<PShape>> vertexM;
  HashMap<PShape, ArrayList<PVector>> faces;

  //Vertex_Vertex
  HashMap<PVector, HashSet<PVector>> vertexMesh;


  // rendering mode
  boolean retained;

  // visual modes
  // 0. Faces and edges
  // 1. Wireframe (only edges)
  // 2. Only faces
  // 3. Only points
  int mode;

  // visual hints
  boolean boundingSphere;

  Mesh() {
    buildMeshRepresentation();
  }

  void buildMeshRepresentation() {

    //Face-Vertex
    vertexM = new HashMap<PVector, ArrayList<PShape>>();
    faces = new HashMap<PShape, ArrayList<PVector>>();

    //Vertex-Vertex
    vertexMesh = new HashMap<PVector, HashSet<PVector>>();

    shape = loadShape("dodecahedron.obj");
    shape.scale(200);

    //Face-Vertex
    for(int j = 0; j < shape.getChildCount(); j++) {
      if(!faces.containsKey(shape.getChild(j))) {
        faces.put(shape.getChild(j), new ArrayList<PVector>());
      }
      for (int i = 0; i < shape.getChild(j).getVertexCount(); i++) {
          PVector v = shape.getChild(j).getVertex(i);
          if (!vertexM.containsKey(v)) {
            vertexM.put(v, new ArrayList<PShape>());
          }
          vertexM.get(v).add(shape.getChild(j));
          faces.get(shape.getChild(j)).add(v);
      }
    }

    // Vertex-Vertex Representation
    PVector o;

    for (PVector v: vertexM.keySet()) {
      for (PShape p: vertexM.get(v)) {
        for (int i = 0; i < p.getVertexCount(); i++){
          o = p.getVertex(i);

          if (o.equals(v)) {
            continue;
          }

          if (!vertexMesh.containsKey(v)) {
            vertexMesh.put(v,new HashSet<PVector>());
          }
          vertexMesh.get(v).add(o);
        }
      }
    }
  }

  void edges(){

    pushStyle();
    colorMode(RGB);
    stroke(255, 0, 0);
    for (int i = 0; i < shape.getChildCount(); i++) {
      for (int j = 0; j < shape.getChild(i).getVertexCount(); j++) {
        PVector p = shape.getChild(i).getVertex(j);
        for(int k = j + 1; k < shape.getChild(i).getVertexCount(); k++) {
          PVector q = shape.getChild(i).getVertex(k);
          line(p.x * 200, p.y * 200, p.z * 200, q.x * 200, q.y * 200, q.z * 200);
        }
      }
    }
    popStyle();
  }

  void points(){

    if (retained) {
      pushStyle();
      stroke(255, 0, 0);
      for (int i = 0; i < shape.getChildCount(); i++) {
        for (int j = 0; j < shape.getChild(i).getVertexCount(); j++) {
          PVector p = shape.getChild(i).getVertex(j);
          point(p.x * 200, p.y * 200, p.z * 200);
        }
      }
      popStyle();
    } else {
      pushStyle();
      colorMode(RGB);
      stroke(255, 0, 0);
      for (PVector v : vertexMesh.keySet()) {
        point(v.x * 200, v.y * 200, v.z * 200);
      }
      popStyle();
    }
  }

  void faces() {

    if (retained) {
      pushStyle();
      shape.setFill(color(0, 50, 255));
      shape(shape);
      popStyle();
    } else {
      pushStyle();
      colorMode(RGB);
      stroke(124, 252, 0);

      for (PShape face : faces.keySet()) {
        face.setFill(color(211, 211, 211));
        shape(face);
      }
      popStyle();
    }
  }

  void draw() {
    pushStyle();

    // mesh visual attributes
    // manipuate me as you wish
    int strokeWeight = 3;
    color lineColor = color(255, retained ? 0 : 255, 0);
    color faceColor = color(0, retained ? 0 : 255, 255, 100);

    strokeWeight(strokeWeight);
    stroke(lineColor);
    fill(faceColor);
    // visual modes
    switch(mode) {
    case 0:
      edges();
      faces();
      break;
    case 1:
      edges();
      break;
    case 2:
      faces();
      break;
    case 3:
      points();
      break;
    }

    popStyle();

    // visual hint
    if (boundingSphere) {
      pushStyle();
      noStroke();
      fill(0, 255, 255, 125);
      sphere(radius);
      popStyle();
    }
  }
}
