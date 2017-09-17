import java.awt.Rectangle;
import java.util.Calendar ;

float limit_ref_min = 0.5, limit_ref_max = 2.5;
 
static int set_width = 1220 , set_height = 420;
int limit_height_min_M2 = 100, limit_height_max_M2 = set_height - 60;

boolean up = false, dn  = false, le = false, ri = false;
boolean pl = false, mi = false, dot = false, qu = false;
int px = 0, dpx = 0;
float ref = 1;
int hei = 160; // diff between mirrors
long tim = 0;
boolean rec = false;
public class Po { // point
 private int xxx = 0 ;
 private int yyy = 0 ;
  
 public void setP(int aa , int bb){
   xxx = aa;
   yyy = bb;
  }
  public int xx() { return xxx; }
  public int yy() { return yyy; }
} 


public class Source { // the box where emitter is kept
  private int xx = 0, yy = 0, hh = 0, ww = 0 ;
  
  public void setX(int ax) { xx = ax; }
  public void setY(int ay) { yy = ay; }
  public void setH(int ah) { hh = ah; }
  public void setW(int aw) { ww = aw; }
  
  public int getX() {return xx;}
  public int getY() {return yy;}
  public int getH() {return hh;}
  public int getW() {return ww;}
  
  // location of centre
  public int getEmX() {return ((int)(xx+ww/2));} 
  public int getEmY() {return ((int)(yy+hh/2));} 
  
  } 
Source li = new Source();

Po M11 = new Po(); Po M12 = new Po(); // top surface
Po M21 = new Po(); Po M22 = new Po(); // bottom surface

void setup()
{
  frameRate(50); 
  //size(set_width,set_height);
   surface.setSize(set_width,set_height);
  noFill();
  li.setX(2) ; li.setY(40);
  li.setW(80); li.setH(20);
  
  M11.setP(85,  60);  M12.setP(width - 2,  60); // M1 is top surface
  M21.setP(5,  hei);  M22.setP(width - 2, hei); // M2 is bottom surface
  px = 100; 
  //  surface.setAlwaysOnTop(true); // optional 
  ref = 1.3; // refractive index (changable)
  //println(asin(0.945) * 180/PI);
}

void draw()
{
  background(0,0,0);
//Rectangle Sou = new Rectangle();
  hei = constrain(hei, limit_height_min_M2, limit_height_max_M2);
  M21.setP(5,  hei);
  M22.setP(width - 2, hei);
  
  text("d:", li.getX() + 70 , li.getY() - 24); 
  text(hei-M11.yy(), li.getX() + 80 , li.getY() - 24); // distance between two mirrors 
  
// draw lines to show mirrors
  line(M11.xx(), M11.yy(), M12.xx(), M12.yy());
  line(M21.xx(), M21.yy(), M22.xx(), M22.yy());
  
  text("R:", li.getX() , li.getY() - 24);
  int reff = ((int)(ref*1000));  float reff2 = (float)reff/1000; // to get 3 digits post decimal of refractive index
  text(reff2, li.getX() + 10, li.getY() - 24);// for displaying refractive index
  
  
  dpx = constrain(dpx, li.getEmX()*5, (li.getX() + li.getW())*5); // 
  int epx = dpx/5; // position of the light beam touching emitter 3rectangle edge (interface), actually this point is moved whem beam rotates
  
  float slS = (((float)(li.getY() + li.getH()) - (float)li.getEmY()) / ((float)epx - (float)li.getEmX())); // angle of beam strinking interface
  int slSi = (int)(100*(atan(slS)*180/PI));
  float slSf = (float)slSi/100;
  text(slSf, li.getX() + 30 , li.getY() - 5);
  text("A:", li.getX() + 20 , li.getY() - 5); // display light angle entering the interface 

  float aslS = sin( PI/2 - (atan(slS) ))  / ref; aslS = tan((PI/2- asin(aslS))); // finding slope of refracted ray
  //px = (int)((float)(float)epx + (float)(  ( M22.yy() - (li.getY() + li.getH()) ) / (slS) ) );
  px = (int)((float)((float)epx + (float)(  ( M22.yy() - (li.getY() + li.getH()) ) / (aslS) )) );  // get point where light will strike M2
  //px = dpx/4;
  px = constrain(px, M21.xx(), M22.xx());
  float s1, ans1;
  s1 = (((float)M22.yy() - (float)(li.getY() + li.getH()) ) / ((float)px - (float)epx)); //get slope of reflected line
  if (px != li.getEmX())
  ans1 = (atan(s1) * (180/PI) );
  else ans1 = 90;

  line(li.getEmX(), li.getEmY(), epx,  li.getY() + li.getH()); // draw ray from souurce to interface
  stroke(255 , 0, 0);
  line(epx, li.getY() + li.getH(), px,  M22.yy()); // draw refracted ray from interface to M2
  stroke(0 , 125, 255); line(px,M22.yy()+10, px, M22.yy() - 24 );
  boolean upar = false; // indicates position of current ray's destination Mirror, if false, it's M2  
  strokeWeight(2); stroke(255,255,255);  stroke(0 , 0, 255);
  rect(li.getX(), li.getY(), li.getW(), li.getH()); // draw source box
  IntList pxx = new IntList(); pxx.append( px);  // create dynamic array for listing all 'x' points of reflection
  FloatList sl = new FloatList(); sl.append(s1); // create dynamic array for listing all slopes of lines
  int pxL = (int)((float)px -  (float)((M22.yy() - M12.yy()) / s1 ));  // get x of detination of first reflcted ray
  int count = 0;
  int con = 1;
  textSize(11);
  while (pxL < M22.xx() && pxL >= M21.xx() && count < 2000) { // while the x coordinate fits the screen or reflections are less than 20000
    
    if (upar) { // if the point we're dealing with is on the upper mirror (M1)
      stroke(255 , 0, 0);
      int pxk = (int)((float)pxx.get(count) -  (float)(M22.yy() - M12.yy())/sl.get(count) ); // get the x of where the reflected ray will collide on M2
      pxx.append(pxk); upar = false; pxL = pxk;
      line(pxx.get(count), M11.yy(), pxx.get(count+1), M22.yy() ); 
      float slo = ( ( (float)M22.yy() - (float)M11.yy() ) / ( (float)pxx.get(count+1) - (float)pxx.get(count) ) ); 
      sl.append(slo); stroke(0 , 125, 255); // get the slope (calculated above) of reflected ray for next calculation
      line(pxk,M22.yy()+10, pxk, M22.yy() - 24 ); // draws vertical line for better visiility of point of reflections on scale
      if (count < 300 ) {
        text(con, pxx.get(count)-7, M11.yy() + 37 + ((con%4)*5) ); // displays the numner of times the ray has reflected yet
        con++;
        }
      }
      
    else  { 
      stroke(0 , 255, 0);
      int pxk = (int)((float)pxx.get(count) - (float)(M12.yy() - M22.yy())/sl.get(count) ); // get the x of where the reflected ray will collide on M1
      pxx.append(pxk); upar = true; pxL = pxk;
      line(pxx.get(count), M22.yy(), pxx.get(count+1),  M11.yy()); 
      float slo = ( ( (float)M11.yy() - (float)M22.yy()) / ((float)pxx.get(count+1) - (float)pxx.get(count)));
      sl.append(slo); stroke(125 , 0, 255); // store the slope (calculated above) of reflected ray for next calculation
      line(pxk,M11.yy()-10, pxk, M11.yy() + 24); // draws vertical line for better visiility of point of reflections on scale
      if (count < 300 ) {
        text(con, pxx.get(count)-7, M22.yy() - 37 + ((int((con%4)/3))*10) );  // displays the numner of times the ray has reflected yet
        con++;
        } 
      }
    count++;
   }
  text("Press R to save ", 130 , set_height - 5);
  text("Press ( up/down ) to move mirror ", 280 , set_height - 5);
  text("Press ( right/left ) to move ray  ", 500 , set_height - 5);
  text("Press ( +/- ) to change refractive index ", 700 , set_height - 5);

if (ref < 1 && 90 - slSf > (asin(ref) * 180/PI) ){ // finds if total internal reflection has occured // critical angle = asin(n1/n2)
  text("Critical angle exceeded",  set_width/2 - 30,  (M22.yy()+M12.yy())/2);
  text("Total internal reflection will occur", set_width/2 - 40,  (M22.yy()+M12.yy())/2 + 20);
}
//println(epx + " ;; " + ref + "  " + slS +  "  " + aslS);  
//println(px - li.getEmX() + "  " + s1 + "  " + epx + "  " + ref);  
//println(width + "  " + height );
  if (ri) dpx++;
  if (le) dpx--;
  if (pl) { ref += 0.005; pl = false;}
  if (mi) { ref -= 0.005; mi = false;}
  if (up) { hei -= 1; up = false;}
  if (dn) { hei += 1; dn = false;}
  if (ref < limit_ref_min ) ref = limit_ref_min;
  if (ref > limit_ref_max ) ref = limit_ref_max;
  
  stroke(255 , 255, 255);
//println(hei);
// draw horizontal scale to indicate x of points of reflections, the y can be calculated by vertical distance, which is displayed 
  for (int ii = 0; ii < width ; ii+=10) {
    if (ii < width && ii > 0 ) {
      line(ii, M22.yy(), ii, M22.yy() + 5); 
      if (ii > 80) line(ii, M11.yy(), ii, M11.yy() - 5) ; 
      }
  
      if (ii%40 == 0) {
        text(ii, ii - 6 , M22.yy() + 40); 
        line(ii, M22.yy() + 5, ii, M22.yy() + 15);
        if (ii > 80) {
          text(ii, ii - 6 , M11.yy() - 30); 
          line(ii, M11.yy() - 5, ii, M11.yy() - 15);
        }
      }
  }
  if (rec) { // saves dateed screenshot in the current folder
     String da = year() + "-" + month() + "-" + day() + "-" + hour() +":" + minute() + ":" + second() ;  
     saveFrame("output/" + da + ".png"); rec = false; println("recorded at " + (millis()/1000) + "s after boot") ; tim = millis();
    }
    if (millis() - tim < 1500 && tim > 0 ) text("saved..", li.getX() + 150 , li.getY() - 20);
    
    if (qu) exit();
}

void keyPressed()
{
      switch (keyCode)
  {
     case LEFT  : {le = true;} break; case RIGHT : {ri = true;} break;
     case UP    : {up = true;} break; case DOWN  : {dn = true;} break;
  }

  switch (key)
  {
      case '+' : {pl  = true;} break;  case '-' : {mi = true;} break;    
      case '.' : {dot = true;} break;  
      case 'r' : {rec = true;} break; case 'R' : {rec = true;} break;
      case '`' : {qu  = true;} break; case '~' : {qu  = true;} break;
  }   
}

void keyReleased()
{
    switch (keyCode)
    {
       case LEFT  : {le = false;} break; case RIGHT : {ri = false;} break;
       case DOWN  : {dn = false;} break; case UP    : {up = false;} break; 
    }
     
   switch (key)
   {
  ///    case '+' : { pl = false;} break;    case '-' : {mi = false;} break;
      case '.' : {dot = false;} break;
   }
}