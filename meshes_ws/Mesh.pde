PShape s;
import java.util.*;

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
  // mesh representation

  //Face_Vertex
  HashMap<PVector, ArrayList<PShape>> vertex_;
  HashMap<PShape, ArrayList<PVector>> faces;

  //Vertex_Vertex
  HashMap<PVector, HashSet<PVector>> vertex_vertex;


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
    build_vertex_vertex();
  }

  // compute both mesh vertex_ and pshape
  void build_vertex_vertex() {

    //Face-Vertex Representation
    vertex_ = new HashMap<PVector, ArrayList<PShape>>();
    faces = new HashMap<PShape, ArrayList<PVector>>();

    //Vertex-Vertex Representation
    vertex_vertex = new HashMap<PVector, HashSet<PVector>>();

    s = loadShape("dodecahedron.obj");
    s.scale(200);
    print(s.getChildCount());

    //Face-Vertex Representation
    for(int j = 0; j < s.getChildCount(); j++) {
      if(!faces.containsKey(s.getChild(j))) {
        faces.put(s.getChild(j), new ArrayList<PVector>());
      }
      for (int i = 0; i < s.getChild(j).getVertexCount(); i++) {
          PVector v = s.getChild(j).getVertex(i);
          if (!vertex_.containsKey(v)) {
            vertex_.put(v, new ArrayList<PShape>());
          }
          vertex_.get(v).add(s.getChild(j));
          faces.get(s.getChild(j)).add(v);
      }
    }

    // Vertex-Vertex Representation
    PVector o;

    for (PVector v: vertex_.keySet()) {
      for (PShape p: vertex_.get(v)) {
        for (int i = 0; i < p.getVertexCount(); i++){
          o = p.getVertex(i);

          if (o.equals(v)) {
            continue;
          }

          if (!vertex_vertex.containsKey(v)) {
            vertex_vertex.put(v,new HashSet<PVector>());
          }
          vertex_vertex.get(v).add(o);
        }
      }
    }
  }

  void print_edges(){

    pushStyle();
    colorMode(RGB);
    stroke(255, 0, 0);
    for (int i = 0; i < s.getChildCount(); i++) {
      for (int j = 0; j < s.getChild(i).getVertexCount(); j++) {
        PVector p = s.getChild(i).getVertex(j);
        for(int k = j + 1; k < s.getChild(i).getVertexCount(); k++) {
          PVector q = s.getChild(i).getVertex(k);
          line(p.x * 200, p.y * 200, p.z * 200, q.x * 200, q.y * 200, q.z * 200);
        }
      }
    }
    popStyle();
  }

  void print_points(){

    if (retained) {
      pushStyle();
      stroke(255, 0, 0);
      for (int i = 0; i < s.getChildCount(); i++) {
        for (int j = 0; j < s.getChild(i).getVertexCount(); j++) {
          PVector p = s.getChild(i).getVertex(j);
          point(p.x * 200, p.y * 200, p.z * 200);
        }
      }
      popStyle();
    } else {
      pushStyle();
      colorMode(RGB);
      stroke(124, 252, 0);
      for (PVector v : vertex_vertex.keySet()) {
        point(v.x * 200, v.y * 200, v.z * 200);
      }
      popStyle();
    }
  }

  void print_faces() {

    if (retained) {
      pushStyle();
      s.setFill(color(0, 50, 255));
      shape(s);
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
      print_edges();
      print_faces();
      break;
    case 1:
      print_edges();
      break;
    case 2:
      print_faces();
      break;
    case 3:
      print_points();
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
