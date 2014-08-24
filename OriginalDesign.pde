/* @pjs preload="enemy1.png; enemy2.png; player.png; */
//import processing.opengl.*;
//import javax.media.opengl.*;

//arrays that hold your bullets and the enemies
Bullet bulletHolder[]= new Bullet[100];
Enemy enemyHolder[] = new Enemy [50];
//count used to iterate through the arrays above;
int count = 0;
int enemyCount = 0;

//time between spawns in ms
int time = 50;
int spawn = 0;

//holds your score for the game
int score = 0;

//when you lose this is set to true
boolean gameOver = false;

PImage enemy1Image;
PImage enemy2Image;
PImage playerImage;

void setup(){
  size(500,500,P3D); 
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
			   ellipse(bulletHolder[i].x, bulletHolder[i].y, 10, 10); 
			   bulletHolder[i].x -= (int) (bulletHolder[i].moveX);
			   bulletHolder[i].y -= (int) (bulletHolder[i].moveY);
				for(int a =0; a<50; a++){
				   if(enemyHolder[a] != null && bulletHolder[i]!= null && bulletHolder[i].x < enemyHolder[a].x + enemyHolder[a].charSize && bulletHolder[i].x > enemyHolder[a].x && bulletHolder[i].y < enemyHolder[a].y + enemyHolder[a].charSize && bulletHolder[i].y > enemyHolder[a].y){
					   enemyHolder[a].life -= 1;
					   enemyHolder[a].charSize +=2;
					   bulletHolder[i] = null;
				   }
				}
		   }

		}
  }
  
  //allows for character movement through arrows and wasd
  public void move(){
	if (keyPressed) {
		if (key == 'W' || key == 'w') {
			you.y-=5;
		}
		if (key == 'A' || key == 'a') {
			you.x-=5;
		}
		if (key == 'S' || key == 's') {
			you.y+=5;
		}
		if (key == 'D' || key == 'd') {
			you.x+=5;
		}
		if (key == CODED) {
			if (keyCode == UP) {
			  you.y-=5;
			} 
			
			if (keyCode == DOWN) {
			  you.y+=5;
			} 
			
			if (keyCode == LEFT) {
			  you.x-=5;
			} 
			
			if (keyCode == RIGHT) {
			  you.x+=5;
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
}

//spawns enemy
void spawnNorm(){
  enemyHolder[enemyCount] = new Enemy(20,(int) random(10, 490),-10, 10, 2);
  enemyCount++;
}

//controles enemy death and movement.
void enemyControl(){

	spawn++;
	if(spawn%time == 0){
		spawnNorm();	
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
		   if(enemyHolder[i].y >= 480){
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
	}
}
	



void draw(){
        smooth();
	background(255,255,255);
	if(gameOver){
		fill(0, 0, 0);
		textSize(32);
		text("Game Over", 170, 150); 
		text("Score: "+score, 170, 250);
	} else {
	checkCount();


	noStroke();
	image(playerImage,you.x, you.y, you.charSize, you.charSize);
	enemyControl();
	you.shoot();
	you.move();
	
	fill(0, 0, 0);
	textSize(32);
	text("Score: "+score, 350, 50); 
	}

}
