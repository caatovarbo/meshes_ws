import java.util.*;

class FaceVertexMesh {

    // radius refers to the mesh 'bounding sphere' redius.
    float radius = 200;
    PShape shape;

    // Face-Vertex representation
    HashMap<PVector, ArrayList<PShape>> vertexM;
    HashMap<PShape, ArrayList<PVector>> faces;

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

    FaceVertexMesh() {
      build();
    }

    void build() {

      vertexM = new HashMap<PVector, ArrayList<PShape>>();
      faces = new HashMap<PShape, ArrayList<PVector>>();

      // Se carga el objeto
      shape = loadShape("dodecahedron.obj");
      shape.scale(200);

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

    }// Fin Build

    void edges(){

      if (retained) {
        pushStyle();
        stroke(color(255, 0, 0));
        for(int i = 0; i < shape.getChildCount(); i++) {
          for(int j = 0; j < shape.getChild(i).getVertexCount(); j++){
              PVector p = shape.getChild(i).getVertex(j);
              for(int k = j + 1; k < shape.getChild(i).getVertexCount(); k++){
                PVector q = shape.getChild(i).getVertex(k);
                line(p.x * 200, p.y * 200, p.z * 200, q.x * 200, q.y * 200, q.z * 200);
              }
          }
        }
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
      edges();
      faces();

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