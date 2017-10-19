import java.util.*;

//PShape shape;

class VertexVertexMesh {

  // radius refers to the mesh 'bounding sphere' redius.
  float radius = 200;
  PShape shape;

  // Vertex-Vertex representation
  HashMap<PVector, HashSet<PVector>> vertices;

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

  VertexVertexMesh(HashMap<PVector, ArrayList<PShape>> vertexM) {
    build(vertexM);
  }

  VertexVertexMesh(){}

  void build(HashMap<PVector, ArrayList<PShape>> vertexM) {

    vertices = new HashMap<PVector, HashSet<PVector>>();

    // Se carga el objeto
    shape = loadShape("dodecahedron.obj");
    shape.scale(200);

    PVector o;

    for (PVector v: vertexM.keySet()) {
      for (PShape p: vertexM.get(v)) {
        for (int i = 0; i < p.getVertexCount(); i++){
          o = p.getVertex(i);

          if (o.equals(v)) {
            continue;
          }

          if (!vertices.containsKey(v)) {
            vertices.put(v,new HashSet<PVector>());
          }
          vertices.get(v).add(o);
        }
      }
    }
  }

  void edges(){

    if (retained) {
      pushStyle();
      shape.setVisible(false);
      //shape.setFill(color(0, 50, 255));
      shape(shape);
      popStyle();
    } else {
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
    edges();
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