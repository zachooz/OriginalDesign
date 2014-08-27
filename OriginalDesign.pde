/* @pjs preload="enemy1.png; enemy2.png; player.png; */;

//arrays that hold your bullets and the enemies
Bullet bulletHolder[]= new Bullet[100];
Enemy enemyHolder[] = new Enemy [50];
PowerUp powerUpHolder[] = new PowerUp [10];
//count used to iterate through the arrays above;
int count = 0;
int enemyCount = 0;
int powerUpCount = 0;

//time between spawns in ms
int time = 50;
int spawn = 0;

//holds your score for the game
int score = 0;

int enemySize = 20;

int bulletSize = 10;

//when you lose this is set to true
boolean gameOver = false;
//images
PImage enemy1Image;
PImage enemy2Image;
PImage playerImage;
//sets up
void setup(){
  size(500,500); 
  background(0,0,0);
  enemy1Image = loadImage("enemy1.png");
  enemy2Image = loadImage("enemy2.png");
  playerImage = loadImage("player.png");
}

//class for the bullets your character shoots
public class Bullet {
	int x;
	int y;
	double moveX;
	double moveY;
	
	Bullet(int x,int y){
	this.x = x;
	this.y=y; 
	}
}




//class for your character
public class Player {
  int x;
  int y;
  int charSize;
  Player(int x,int y,int charSize){
   this.x = x;
   this.y=y; 
   this.charSize = charSize; 
  }
  
  //method makes character shoots bullet
  public void shoot(){
		//if mouse is pressed instantiate a bullet with a speed towards where your mouse was held down
		if(mousePressed){
		  bulletHolder[count] = new Bullet(you.x + 10,you.y + 10);
		  bulletHolder[count].moveX = (bulletHolder[count].x-mouseX) * (10/dist(bulletHolder[count].x,bulletHolder[count].y,mouseX,mouseY));
		  bulletHolder[count].moveY = (bulletHolder[count].y-mouseY) * (10/dist(bulletHolder[count].x,bulletHolder[count].y,mouseX,mouseY));
		  count++;
		}
		//check if bullet has hit an enemy
		for(int i =0; i<100; i++){
		   if(bulletHolder[i] != null){
			   fill(0,255,0);
			   ellipse(bulletHolder[i].x, bulletHolder[i].y, bulletSize, bulletSize); 
			   bulletHolder[i].x -= (int) (bulletHolder[i].moveX);
			   bulletHolder[i].y -= (int) (bulletHolder[i].moveY);
				for(int a =0; a<50; a++){
				   if(enemyHolder[a] != null && bulletHolder[i]!= null && bulletHolder[i].x - bulletSize/2 < enemyHolder[a].x + enemyHolder[a].charSize && bulletHolder[i].x + bulletSize/2 > enemyHolder[a].x && bulletHolder[i].y - bulletSize/2 < enemyHolder[a].y + enemyHolder[a].charSize && bulletHolder[i].y + bulletSize/2 > enemyHolder[a].y){
					   enemyHolder[a].life -= 1;
					   enemyHolder[a].charSize +=2;
					   bulletHolder[i] = null;
				   }
				   if(a<10){
					   if(powerUpHolder[a] != null && bulletHolder[i]!= null && bulletHolder[i].x - bulletSize/2 < powerUpHolder[a].x + powerUpHolder[a].charSize && bulletHolder[i].x + bulletSize/2 > powerUpHolder[a].x && bulletHolder[i].y - bulletSize/2 < powerUpHolder[a].y + powerUpHolder[a].charSize && bulletHolder[i].y + bulletSize/2 > powerUpHolder[a].y){
					   	   bulletSize++;
						   bulletHolder[i] = null;
						   powerUpHolder[a] = null;

					   }
				   }
				}
		   }

		}
  }
  
  //allows for character movement through arrows and wasd
  public void move(){
	if (keyPressed) {
		if (key == 'W' || key == 'w') {
			if(you.y-5 >=0) you.y-=5;
		}
		if (key == 'A' || key == 'a') {
			if(you.x-5 >=0) you.x-=5;
		}
		if (key == 'S' || key == 's') {
			if(you.y+5 <=height-you.charSize) you.y+=5;
		}
		if (key == 'D' || key == 'd') {
			if(you.x+5 <=width-you.charSize) you.x+=5;
		}
		if (key == CODED) {
			if (keyCode == UP) {
			  if(you.y-5 >=0) you.y-=5;
			} 
			
			if (keyCode == DOWN) {
			  if(you.y+5 <=height-you.charSize) you.y+=5;
			} 
			
			if (keyCode == LEFT) {
			  if(you.x-5 >=0) you.x-=5;
			} 
			
			if (keyCode == RIGHT) {
			  if(you.x+5 <=width-you.charSize) you.x+=5;
			} 
		}
	}
  }
}

//class for the enemies
public class Enemy {
	int x;
	int y;
	int charSize;
	int life;
	int speed;
	int phase = 1;
	Enemy(int charSize, int x, int y, int life, int speed){
	this.x = x;
	this.y=y; 
	this.charSize = charSize; 
	this.life = life;
	this.speed = speed;
	}
}



//class for powerup
public class PowerUp {
	int x;
	int y;
	int charSize;
	int life;
	int speed;
	PowerUp(int charSize, int x, int y, int life, int speed){
	this.x = x;
	this.y=y; 
	this.charSize = charSize; 
	this.life = life;
	this.speed = speed;
	}
}


//instantiates player
Player you = new Player(240, 400, 20);

//resets count when it reaches end of the array
void checkCount(){
	if(count >= 100){
		count = 0;
	}
	if(enemyCount >= 50){
		enemyCount = 0;
	}
	if(powerUpCount>=10){
		powerUpCount = 0;
	}
}

//spawns enemy
void spawnNorm(){
  enemyHolder[enemyCount] = new Enemy(enemySize,(int) random(10, 490),-10, 10, 2);
  enemyCount++;
}

void spawnPower(){
  powerUpHolder[powerUpCount] = new PowerUp(20,(int) random(10, 490),-10, 10, 2);
  powerUpCount++;
}


//controles enemy death and movement.
void enemyControl(){

	spawn++;
	if(spawn%time == 0){
		spawnNorm();	
	}

	if(spawn%1000 == 0){
		spawnPower();	
	}

	for(int i =0; i<50; i++){
	   if(enemyHolder[i] != null){
			if(enemyHolder[i].phase == 1){
				image(enemy1Image,enemyHolder[i].x, enemyHolder[i].y, enemyHolder[i].charSize, enemyHolder[i].charSize);
			} else {
				image(enemy2Image,enemyHolder[i].x, enemyHolder[i].y, enemyHolder[i].charSize, enemyHolder[i].charSize);
			}

		   if(enemyHolder[i].phase == 1){
				enemyHolder[i].y += (int) (enemyHolder[i].speed);
		   }
		   if(enemyHolder[i].y >= height-enemyHolder[i].charSize){
			 enemyHolder[i].phase = 2;
		   }
		   	if(enemyHolder[i].phase == 2){
				float moveXEnemy = (enemyHolder[i].x-you.x) * (2/dist(enemyHolder[i].x,enemyHolder[i].y,you.x,you.y));
				float moveYEnemy = (enemyHolder[i].y-you.y) * (2/dist(enemyHolder[i].x,enemyHolder[i].y,you.x,you.y));
				enemyHolder[i].x -= (int) (moveXEnemy);
				enemyHolder[i].y -= (int) (moveYEnemy);
		   }
		   	if(enemyHolder[i].life <=0){
				enemyHolder[i] = null;
				score++;
				if(time>15){
					time--;
				}
		   }
		   
		   if(enemyHolder[i] != null && you.x <= enemyHolder[i].x + enemyHolder[i].charSize && you.x + 15 >= enemyHolder[i].x && you.y <= enemyHolder[i].y + enemyHolder[i].charSize && you.y +15 >= enemyHolder[i].y) {
				gameOver = true;
				print("gameOver");
		   }
		}
	    if(i<10 && powerUpHolder[i] != null){
	    	fill(255, 200, 0);
	    	noStroke();
			ellipse(powerUpHolder[i].x, powerUpHolder[i].y, powerUpHolder[i].charSize, powerUpHolder[i].charSize);
		   
			powerUpHolder[i].y += (int) (powerUpHolder[i].speed);
		}
	}
	
}

	


//draws out all functions
void draw(){
        smooth();
	background(255,255,255);
	if(gameOver){
		fill(0, 0, 0);
		textSize(32);
		text("Game Over", width - 330, 150); 
		text("Score: "+score, width - 330, 250);
	} else {
	checkCount();


	noStroke();
	image(playerImage,you.x, you.y, you.charSize, you.charSize);
	enemyControl();
	you.shoot();
	you.move();
	
	fill(0, 0, 0);
	textSize(32);
	text("Score: "+score, width - 170, 50); 
	}

}
