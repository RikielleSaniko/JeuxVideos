class Player{
  PVector position;
  PVector velocity;
  float power = 200;
  
  
  
  Player(){
    position = new PVector(15, height - 15);
    velocity = new PVector(5,0);
  }
  
  void playerMovement(){
  if(keyPressed){
    if(key == 'a' || key == 'A'){
      position.sub(velocity); 
    }
    
    if(key == 'd' || key == 'D'){
      position.add(velocity); 
    }
  }
  position.x = constrain(position.x, 15, width - 15);
}

PVector attract( Particle particle) {
    PVector force = PVector.sub(this.position, particle.position);
    float distance = force.mag();
    distance = constrain(distance, 5, 50);
    float strength = this.power / (distance * distance);
    force.setMag(strength);
    return force;
  }
  
 void display(){
    fill(0); 
    ellipse(position.x, position.y, 30, 30);
  }

}
