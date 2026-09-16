class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color particuleColor;
  color attractedColor = color(0, 255, 0);
  
  int maxParticles = 100;



  Particle() {
    position = new PVector(width/2, height/3);
    initialize();
  }

  Particle(PVector l) {
    position = l.copy();
    initialize();
  }
  
  void applyForce(PVector force) {
      acceleration.add(force);
    }


  void initialize() {
    velocity = new PVector(random(-2, 2), random(-2, 0));
    acceleration = new PVector(0, 0.05);
    lifespan = 300;
    particuleColor = color(50, 0, 200);

  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2.0;

    if(isDead()) {
      reset();
    }
  }

  void display() {
    stroke(0, lifespan);
    fill(particuleColor, lifespan);
    ellipse(position.x, position.y, 10, 10);
  }

  boolean isDead() {
    return lifespan < 0.0;
  }

  void reset() {
    position.set (width/2,  height/3);
    velocity.set (random(-2, 2), random(-2, 0));    
    lifespan = 300;
    acceleration = new PVector(0, 0.05);
    particuleColor = color(50, 0, 200);
    
  }
  
  void changeColor(){
    particuleColor = attractedColor;
  }
}
