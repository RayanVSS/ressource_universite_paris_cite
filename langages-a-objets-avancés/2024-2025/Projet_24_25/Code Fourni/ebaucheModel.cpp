#include <utility> // pour pair
#include <vector>
using namespace std;
class PieceOperateur;
class Piece {
	public :
	virtual void trigger(const pair<int,int> & coord , Piece &origin)=0;
	void trigger(const pair<int,int> & coord ) { trigger(coord, *this); }
	virtual const vector<pair<int, int>>& getCoordinates() const =0  ;
	virtual void accept(const PieceOperateur &v)=0;
};

class PieceConcrete : public Piece {
	public :
	vector<pair<int, int>> coordinates;
	PieceConcrete(const vector<pair<int, int>>& coords): coordinates(coords) {}
	const vector<pair<int, int>>& getCoordinates() const { return coordinates; }
	void trigger(const pair<int,int> & coord, Piece &origin) {}
	void accept(const PieceOperateur & v);
};

class OperateurDeplacement;
class PieceOperateur : public Piece {
	public:
	Piece & source;
	pair<int, int> position;
	PieceOperateur(Piece & source, const pair<int,int> & position) 
		: source{source},position{position} {}
	const vector<pair<int, int>>& getCoordinates() const {return source.getCoordinates();}
	void trigger(const pair<int,int> & relativePos, Piece &origin) {
		if (relativePos==position) origin.accept(*this);
		else source.trigger(relativePos, origin);
	}
	
	virtual void mapPosition(pair<int, int> &) const =0; 
	virtual void visit(PieceConcrete &p) const { 
		for (pair<int,int> &x : p.coordinates)  mapPosition(x);
	}
	
	virtual void visit(OperateurDeplacement &) const =0;
	//virtual void visit(OperateurRotation &) const =0;
	//virtual void visit(OperateurSymetrie &) const =0;
	
	virtual void accept(const PieceOperateur &v)=0;
	
};
enum OrientationDeplacement {NORD, SUD, EST, OUEST};
class OperateurDeplacement : public PieceOperateur
{
	public:
	OrientationDeplacement sens;
	OperateurDeplacement(Piece & source, const pair<int,int> & position, OrientationDeplacement sens) : PieceOperateur(source,position) , sens{sens} {};
	virtual void accept(const PieceOperateur &v) { v.visit(*this); }
	virtual void visit(OperateurDeplacement &x) const {
		// le deplacement ne modifie pas le sens
		mapPosition(x.position);
		x.source.accept(*this); 
	}
	//virtual void visit(OperateurRotation &x) const;
	//virtual void visit(OperateurSymetrie &x) const;
	
	virtual void mapPosition( pair<int, int> & pos) const {
		switch (sens) {
			case NORD : pos.second--; break;
			case SUD : pos.second++; break;
			case EST : pos.first++; break;
			case OUEST : pos.first--; break;
		}
	}
};
void PieceConcrete::accept(const PieceOperateur &v) {v.visit(*this);}

int main() {
	vector<pair<int, int>> coords { {0, 0}, {0, 1}, {0, 2}, {1, 2}};     
	PieceConcrete tetris_L(coords);
	Piece *p = new OperateurDeplacement {tetris_L,{0,0},EST};
	p->trigger(make_pair(0,0));
	p->trigger(make_pair(1,0));
}

