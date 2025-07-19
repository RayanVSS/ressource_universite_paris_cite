#include <iostream>
#include <SFML/Graphics.hpp> 
using namespace sf;
using namespace std;

int main(){
   // definition de la fenêtre
    RenderWindow app(VideoMode(800, 600, 32), "Ma premiere fenetre SFML ! ");
  // Hello world
  Font font;
 font.loadFromFile("./Agatha.ttf");
 Text text;
 text.setFont(font);
 text.setString("  Hello world");
 text.setCharacterSize(100); // in pixels, not points!
 text.setFillColor(Color::Red);
 //text.setStyle(Text::Bold | Text::Underlined);

  // Un element graphique, associé à une image
 Texture texture;
 texture.loadFromFile("./fleurs.png");
 Sprite tuile;
 tuile.setTexture(texture);
 tuile.setScale(Vector2f(0.5,0.5));
 tuile.move(Vector2f(200, 200));
 
// idem pour une seconde tuile :
 Texture tex;
 tex.loadFromFile("./fleur2.png");
 Sprite tuile2;
 tuile2.setTexture(tex);

// pour une petite animation
Sprite * current =& tuile;
   // Boucle principale

    while (app.isOpen())
    {
        Event event;
        while (app.pollEvent(event))
   		 switch (event.type) {
       	 		case Event::Closed: 
				app.close();
				break;
        
        		case Event::KeyPressed:
            			if (event.key.code==Keyboard::Return) cout << "salut"  << endl;
            			break;

        		default:
            			break;
     		 }
	// fin du while

	// en dehors de la gestion des événements c'est plus fluide
	if (Keyboard::isKeyPressed(Keyboard::Right))  current ->move(1, 0);	
	if (Keyboard::isKeyPressed(Keyboard::Left))  current ->move(-1, 0);	
        if (Keyboard::isKeyPressed(Keyboard::Up))  current ->move(0, -1);	
	if (Keyboard::isKeyPressed(Keyboard::Down)) current ->move(0, 1);	

        // Remplissage de l'écran (couleur noire par défaut)
        app.clear();

    // Store the bounding box of the sprite
    FloatRect bounds_t1 = tuile.getGlobalBounds();    
    FloatRect bounds_t2 = tuile2.getGlobalBounds();
  // rq: je l'ai mis là et pas dans la gestion des évenements... surement que ce serait mieux là bas
   if(Mouse::isButtonPressed(Mouse::Left)) {
    	// transform the mouse position from window coordinates to world coordinates
    	Vector2f mouse = app.mapPixelToCoords(Mouse::getPosition(app));
   	// select the current Sprite
    	if (bounds_t1.contains(mouse)) current = & tuile;  
    	if (bounds_t2.contains(mouse)) current = & tuile2;
	}

        // dessin en interne de nos Sprites
        //app.draw(tuile);
	//app.draw(tuile2);
	app.draw(text);

        // Affichage de la fenêtre à l'écran
        app.display();
    }
    return EXIT_SUCCESS;
}
