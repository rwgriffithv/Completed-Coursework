#ifndef MYMAP_INCLUDED
#define MYMAP_INCLUDED

#include <map>  // YOU MUST NOT USE THIS HEADER IN CODE YOU TURN IN

// In accordance with the spec, YOU MUST NOT TURN IN THIS CLASS TEMPLATE,
// since you are not allowed to use any STL associative containers, and
// this implementation uses std::map.

// This code is deliberately obfuscated.

// If you can not get your own MyMap class template working, you may use
// this one during development in order to let you proceed with implementing
// the other classes for this project; you can then go back to working on
// fixing your own MyMap class template.

template <typename KeyType, typename ValueType>
class MyMap
{
public:
	MyMap(const MyMap &other) = delete;
	MyMap &operator=(const MyMap &other) = delete;
typedef KeyType O;using O1=int;void clear(){l01.clear();}
using l0=ValueType;MyMap(){}using l10=O const;O1 size()
const{return l01.size();}using ll0=l0 const;using Const=
MyMap<O,l0>;void associate(l10&Using,ll0&first){l01[
Using]=first;}using l1=std::map<O,l0>;using l00=Const
const;ll0*find(l10&l11)const{auto first=l01.find(l11);
return(first!=l01.end()?&first->second:0);}l0*find(l10&
l01){return(l0*)(*(l00*)(this)).find(l01);}private:l1
l01;
};

#endif // MYMAP_INCLUDED
