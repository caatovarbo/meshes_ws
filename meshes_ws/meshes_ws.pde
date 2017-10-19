VertexVertexMesh mesh;
//FaceVertexMesh mesh;
//WingedVertexMesh mesh;

void setup() {
  size(600, 600, P3D);

  FaceVertexMesh faceVertexMesh = new FaceVertexMesh();
  VertexVertexMesh vertexVertexMesh = new VertexVertexMesh(faceVertexMesh.vertexM);
  WingedVertexMesh wingedVertexMesh = new WingedVertexMesh();

  mesh = vertexVertexMesh;
  //mesh = faceVertexMesh;
  //mesh = wingedVertexMesh;

}

void draw() {
  background(0);
   text("Mesh mode: " + mesh.mode + ". Rendering mode: " + (mesh.retained ? "retained" : "immediate") + ". FPS: " + frameRate, 10 ,10);
  lights();
  // draw the mesh at the canvas center
  // while performing a little animation
  translate(width/2, height/2, 0);
  rotateX(frameCount*radians(90) / 50);
  rotateY(frameCount*radians(90) / 50);
  // mesh draw method
  mesh.draw();
}

void keyPressed() {
  if (key == ' ')
    mesh.mode = mesh.mode < 3 ? mesh.mode+1 : 0;
  if (key == 'r')
    mesh.retained = !mesh.retained;
  if (key == 'b')
    mesh.boundingSphere = !mesh.boundingSphere;
}