int currentTime;
int deltaTime;
int previousTime;

Emitter emitter;
Player player;

void setup() {
  size(800, 600);
  emitter = new Emitter (new PVector( width / 2, height / 3), 10);
  player = new Player();
}

void draw() {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  update(deltaTime);
  display();
}

void update(int deltaTime) {
  player.playerMovement();
  emitter.applyAttraction(player);
  emitter.update(deltaTime);

}

void display() {
  background(255);
  player.display();
  emitter.display();
}
