class Emitter {
  PVector position;
  int particleRate;
  int lastParticleTime;
  ArrayList<Particle> particles;
  int maxParticles = 1000;
  int attractedDistance = 300;
  
  Player player;

  Emitter(PVector l, int rate) {
    position = l.copy();
    particleRate = rate;
    lastParticleTime = 0;
    particles = new ArrayList<Particle>();
  }
  
  void applyAttraction(Player player) {
    for (Particle p : particles) {
      float distance =  dist(player.position.x, player.position.y, p.position.x, p.position.y);
      if(distance < attractedDistance){
        PVector force = player.attract(p);
        p.applyForce(force);
        p.changeColor();
      }

    }
}

  void update(int deltaTime) {
    if (millis() - lastParticleTime > particleRate && particles.size() < maxParticles) {
      lastParticleTime = millis();
      particles.add(new Particle(position));
    }

    for (Particle p : particles) {
      p.update();
    }
  }

  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }
  
  void setDistance(int distance){
    this.attractedDistance = distance;
    
  }
}
