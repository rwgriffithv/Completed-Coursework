#ifndef STUDENTWORLD_H_
#define STUDENTWORLD_H_

#include "GameWorld.h"
#include "Field.h"
#include "Actor.h"
#include <string>
#include <vector>
#include <list>
#include <sstream>

class Compiler;

class StudentWorld : public GameWorld
{
public:
	StudentWorld(std::string assetDir)
		:GameWorld(assetDir), m_tickCount(2000), m_posCurrentWinner(0) {}
	virtual ~StudentWorld();

	virtual int init();
	virtual int move();	
	virtual void cleanUp();

	// keeps track of current winner - used by setDisplayText()
	void setCurrentWinner(); 

	// sets display text
	void setDisplayText();

	// Can an insect move to x,y?
	bool canMoveTo(int x, int y) const;

	// Add an actor to the world
	void addActor(Actor* a);

	void addFood(int x, int y, int amt);

	// If an item that can be picked up to be eaten is at x,y, return a
	// pointer to it; otherwise, return a null pointer.  (Edible items are
	// only ever going be food.)
	Food* getEdibleAt(int x, int y) const;

	// If a pheromone of the indicated colony is at x,y, return a pointer
	// to it; otherwise, return a null pointer.
	Pheromone* getPheromoneAt(int x, int y, int colony) const;

	// Is an enemy of an ant of the indicated colony at x,y?
	bool isEnemyAt(int x, int y, int colony) const;

	// Is something dangerous to an ant of the indicated colony at x,y?
	bool isDangerAt(int x, int y, int colony) const;

	// Is the anthill of the indicated colony at x,y?
	bool isAntHillAt(int x, int y, int colony) const;

	// Bite an enemy of an ant of the indicated colony at me's location
	// (other than me; insects don't bite themselves).  Return true if an
	// enemy was bitten.
	bool biteEnemyAt(Actor* me, int colony, int biteDamage);

	// Poison all poisonable actors at x,y.
	void poisonAllPoisonableAt(int x, int y);

	// Stun all stunnable actors at x,y.
	void stunAllStunnableAt(int x, int y);

	// Record another ant birth for the indicated colony.
	void increaseScore(int colony);



private:
	std::list<Actor*> actors[VIEW_WIDTH][VIEW_HEIGHT];
	std::vector<int> m_scores;
	std::vector<Compiler*> m_comp;
	int m_posCurrentWinner;
	int m_tickCount;
};


#endif // STUDENTWORLD_H_
