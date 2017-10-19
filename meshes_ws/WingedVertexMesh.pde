import java.util.*;


class Edge{
  
  PVector start;
  PVector end;
  
  public Edge(PVector start, PVector end){
    this.start = start;
    this.end = end;
  }
}

class PolygonMesh{
  ArrayList<PVector> vertex;
  ArrayList<Edge> edges;
  ArrayList<PShape> faces;

  public PolygonMesh(ArrayList<PVector> vertex, ArrayList<Edges> edges, ArrayList<PShape> faces){
    this.vertex = vertex;
    this.edges = edges;
    this.faces = faces;
  }

  public void addVertex(PVector v){
    vertex.add(v);
  }
  
  public void addEdge(Edge e){
    this.edges.add(e);
  }

  public void addFace(PShape f){
    faces.add(f);
  }

}

class WingedVertexMesh{

  // Winged-edge representation
      face_list = new HashMap<PShape,ArrayList<Edge>>();
      edge_list = new HashMap<Edge, Info>();
  vertex_list = new HashMap<PVector,ArrayList<Edge>>();
  
  // Winged Edge Representation
      for(int i=0;i< s.getChildCount();i++){
          PShape da_shape = s.getChild(i);
          if(!face_list.containsKey(da_shape)){
            face_list.put(da_shape,new ArrayList<Edge>());
          }
          for(int j=0;j< s.getChild(i).getVertexCount();j++){
              PVector p = da_shape.getVertex(j);
              for(int k=j+1;k< s.getChild(i).getVertexCount();k++){
                PVector q = s.getChild(i).getVertex(k);
                Edge da_edge = new Edge(p,q);
                face_list.get(da_shape).add(da_edge);
                if(!vertex_list.containsKey(q)){
                  vertex_list.put(q,new ArrayList<Edge>());
                }
                vertex_list.get(q).add(da_edge);
                if(!vertex_list.containsKey(p)){
                  vertex_list.put(p,new ArrayList<Edge>());
                }
                vertex_list.get(p).add(da_edge);
                if(!edge_list.containsKey(da_edge)){
                  edge_list.put(da_edge,new Info(new ArrayList<PVector>(), new ArrayList<Edge>(), new ArrayList<PShape>()));
                }
                edge_list.get(da_edge).addVertex(p);
                edge_list.get(da_edge).addVertex(q);
                edge_list.get(da_edge).addFace(da_shape);
              }
          }
       }
    for(PShape face:face_list.keySet()){
      ArrayList<Edge> edges = face_list.get(face);
      for(int i = 0;i<edges.size();i++){
          for(int j=i+1;j<edges.size();j++){
            edge_list.get(edges.get(i)).addEdge(edges.get(j));
            edge_list.get(edges.get(j)).addEdge(edges.get(i));
          }
      }
  }
  void print_edges(){
    
    if (retained){
      pushStyle();
      colorMode(RGB);
      stroke(255,0,0);
      for(int i=0;i< s.getChildCount();i++){
          for(int j=0;j< s.getChild(i).getVertexCount();j++){
              PVector p = s.getChild(i).getVertex(j);
              for(int k=j+1;k< s.getChild(i).getVertexCount();k++){
                PVector q = s.getChild(i).getVertex(k);
                line(p.x*200, p.y*200, p.z*200, q.x*200, q.y*200, q.z*200);
              }
          }
       }
      popStyle();
    }else{
      pushStyle();
      colorMode(RGB);
      stroke(124,252,0);
      for(Edge v: edge_list.keySet()){
          ArrayList<PVector> p = edge_list.get(v).vertex;
          line(p.get(0).x*200, p.get(0).y*200, p.get(0).z*200, p.get(1).x*200, p.get(1).y*200, p.get(1).z*200);
       }
       popStyle();
    }
  }
  
    void print_points(){
    
    if (retained){
      pushStyle();
      stroke(255,0,0);
      for(int i=0;i< s.getChildCount();i++){
          for(int j=0;j< s.getChild(i).getVertexCount();j++){
              PVector p = s.getChild(i).getVertex(j);
              point(p.x*200, p.y*200, p.z*200);
          }
       }
      popStyle();
    }else{
      pushStyle();
      colorMode(RGB);
      stroke(124,252,0);
      for(PVector v: vertex_vertex.keySet()){
            point(v.x*200, v.y*200, v.z*200);
      }
      popStyle();
    }
  }
  
  void print_faces(){
   
    if (retained){
      pushStyle();
      s.setFill(color(0,50,255));
      shape(s);
      popStyle();
    }else{
      pushStyle();
      colorMode(RGB);
      stroke(124,252,0);
      for(PShape face: faces.keySet()){
        face.setFill(color(211,211,211));
        shape(face);
      }
      popStyle();
    }
  }
}