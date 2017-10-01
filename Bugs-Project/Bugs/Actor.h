#ifndef ACTOR_H_
#define ACTOR_H_

#include "GraphObject.h"
#include "Compiler.h"
#include <algorithm>
#include <cmath>
#include <utility>
#include <vector>

//Constants
const int ANT_DAMAGE = 15;
const int ADULT_GRASSHOPPER_DAMAGE = 50;
const int BABY_GRASSHOPPER_HEALTH = 500;
const int ADULT_GRASSHOPPER_HEALTH = 1600;

//Helper Functions

//returns a random direction
GraphObject::Direction randDirection();

//returns an integer corresponding to passed Command operand string
int convertOpToInt(std::string s);



class StudentWorld;

class Actor : public GraphObject
{
public:
	Actor(StudentWorld* world, int startX, int startY, Direction startDir, int imageID, int depth)
		:GraphObject(imageID, startX, startY, startDir, depth, 0.25), m_world(world) {}
	virtual ~Actor() {}

	virtual void doSomething() = 0;

	virtual bool isDead() const;

	virtual bool blocksMovement() const;

	virtual void getBitten(int amt) {}

	virtual void getPoisoned() {}

	virtual void getStunned() {}

	virtual bool isEdible() const;

	virtual bool isPheromone(int colony) const;

	virtual bool isInsect() const;

	virtual bool isEnemy(int colony) const;

	virtual bool isDangerous(int colony) const;

	virtual bool isMyHill(int colony) const { return false; }

	StudentWorld* getWorld() const { return m_world; }

	// Determine if the actor has changed location
	virtual bool checkHasMoved() { return false; }
	virtual void registerMove() {}
	virtual void clearMove() {}

private:
	StudentWorld* m_world;
};






class Pebble : public Actor	//DONE
{
public:
	Pebble(StudentWorld* sw, int startX, int startY)
		:Actor(sw, startX, startY, right, IID_ROCK, 1) {}
	virtual ~Pebble() {}

	virtual void doSomething() {}

	virtual bool blocksMovement() const { return true; }
};







class EnergyHolder : public Actor	//DONE
{
public:
	EnergyHolder(StudentWorld* sw, int startX, int startY, Direction startDir, int energy, int imageID, int depth)
		:Actor(sw, startX, startY, startDir, imageID, depth), m_energy(energy) {}
	virtual ~EnergyHolder() {}

	virtual bool isDead() const { return m_energy <= 0; }

	// Get this actor's amount of energy (for a Pheromone, same as strength).
	int getEnergy() const { return m_energy; }

	// Adjust this actor's amount of energy upward or downward.
	void updateEnergy(int amt) { m_energy += amt; }

	// Have this actor pick up an amount of food and eat it.
	int pickupAndEatFood(int amt);

private:
	int m_energy;
};

class Food : public EnergyHolder	//DONE
{
public:
	Food(StudentWorld* sw, int startX, int startY, int energy)
		:EnergyHolder(sw, startX, startY, right, energy, IID_FOOD, 2) {}
	virtual ~Food() {}

	virtual void doSomething() {}

	virtual bool isEdible() const { return true; }
};

class AntHill : public EnergyHolder
{
public:
	AntHill(StudentWorld* sw, int startX, int startY, int colony, Compiler* program)
		:EnergyHolder(sw, startX, startY, right, 8999, IID_ANT_HILL, 2), m_colony(colony), m_antProgram(program) {}
	virtual ~AntHill() {}

	virtual void doSomething();
	virtual bool isMyHill(int colony) const { return colony == m_colony; }

private:
	int m_colony;
	Compiler* m_antProgram;
};

class Pheromone : public EnergyHolder
{
public:
	Pheromone(StudentWorld* sw, int startX, int startY, int colony)
		:EnergyHolder(sw, startX, startY, right, 256, IID_PHEROMONE_TYPE0 + colony, 2) {}
	virtual ~Pheromone() {}

	virtual void doSomething();

	virtual bool isPheromone(int colony) const { return IID_PHEROMONE_TYPE0 + colony == getID(); }

	// Increase the strength (i.e., energy) of this pheromone.
	void increaseStrength();
};





class TriggerableActor : public Actor	//DONE
{
public:
	TriggerableActor(StudentWorld* sw, int x, int y, int imageID)
		:Actor(sw, x, y, right, imageID, 2) {}
	virtual ~TriggerableActor() {}

	virtual bool isDangerous(int colony) const { return true; }
};

class WaterPool : public TriggerableActor
{
public:
	WaterPool(StudentWorld* sw, int x, int y)
		:TriggerableActor(sw, x, y, IID_WATER_POOL) {}
	virtual ~WaterPool() {}
	virtual void doSomething();
};

class Poison : public TriggerableActor
{
public:
	Poison(StudentWorld* sw, int x, int y)
		:TriggerableActor(sw, x, y, IID_POISON) {}
	virtual ~Poison() {}

	virtual void doSomething();
};





class Insect : public EnergyHolder
{
public:
	Insect(StudentWorld* world, int startX, int startY, int energy, int imageID)
		:EnergyHolder(world, startX, startY, randDirection(), energy, imageID, 1), 
		m_stunnedAtLocation(false), m_sleepTicks(0), m_moved(false) {}
	virtual ~Insect() {}

	virtual void doSomething() { updateEnergy(-1); }

	virtual void getBitten(int amt) { updateEnergy(-amt); }

	virtual void getPoisoned() { updateEnergy(-150); }

	virtual void getStunned();

	virtual bool isEnemy(int colony) { return true; }

	virtual bool isInsect() const { return true; }

	int getSleepTicks() const { return m_sleepTicks; }

	void getXYInFrontOfMe(int& x, int& y) const;

	bool moveForwardIfPossible();

	void updateSleepTicks(int amt) { m_sleepTicks += amt; }

	virtual bool checkHasMoved() { return m_moved; }

	virtual void registerMove() { m_moved = true; }

	virtual void clearMove() { m_moved = false; }

private:
	bool m_stunnedAtLocation;
	int m_sleepTicks;
	bool m_moved;
};

class Ant : public Insect
{
public:
	Ant(StudentWorld* sw, int startX, int startY, int colony, Compiler* program, int imageID)
		:Insect(sw, startX, startY, 1500, colony), m_heldEnergy(0), m_colony(colony), m_prevBitten(false),
		m_prevBlocked(false), m_lastRandNum(0), m_instructionCount(0), m_program(program) {}
	virtual ~Ant() {}

	virtual void doSomething();

	virtual void getBitten(int amt) { updateEnergy(-amt); m_prevBitten = true; }

	virtual bool isEnemy(int colony) const { return colony != m_colony; }

	// Have this actor pick up an amount of food.
	void pickupFood(int amt);

private:
	int m_heldEnergy;
	int m_colony;
	bool m_prevBitten;
	bool m_prevBlocked;
	int m_lastRandNum;
	int m_instructionCount;
	Compiler* m_program;
};

class Grasshopper : public Insect
{
public:
	Grasshopper(StudentWorld* sw, int startX, int startY, int energy, int imageID)
		:Insect(sw, startX, startY, energy, imageID), m_walkDistance(randInt(2, 10)) {}
	virtual ~Grasshopper() {}

	virtual void doSomething();

	virtual bool specificAction() = 0;

private:
	int m_walkDistance;
};

class BabyGrasshopper : public Grasshopper
{
public:
	BabyGrasshopper(StudentWorld* sw, int startX, int startY)
		:Grasshopper(sw, startX, startY, BABY_GRASSHOPPER_HEALTH, IID_BABY_GRASSHOPPER) {}
	virtual ~BabyGrasshopper() {}

	virtual bool specificAction();
};

class AdultGrasshopper : public Grasshopper
{
public:
	AdultGrasshopper(StudentWorld* sw, int startX, int startY)
		:Grasshopper(sw, startX, startY, ADULT_GRASSHOPPER_HEALTH, IID_ADULT_GRASSHOPPER) {}
	virtual ~AdultGrasshopper() {}

	virtual bool specificAction();

	virtual void getBitten(int amt);
	
	virtual void getStunned() {}
	
	virtual void getPoisoned() {}
};

#endif // ACTOR_H_