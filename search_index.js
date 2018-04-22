var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "JGE",
    "title": "JGE",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#JGE-1",
    "page": "JGE",
    "title": "JGE",
    "category": "section",
    "text": "Julia Graphics Engine"
},

{
    "location": "index.html#Start-1",
    "page": "JGE",
    "title": "Start",
    "category": "section",
    "text": "Manual\nDeveloper Documentation"
},

{
    "location": "index.html#Manual-1",
    "page": "JGE",
    "title": "Manual",
    "category": "section",
    "text": "Install\nStart\nSzene"
},

{
    "location": "index.html#Developer-Documentation-1",
    "page": "JGE",
    "title": "Developer Documentation",
    "category": "section",
    "text": "Algorithm\nBuild\nOptimization\nReferences"
},

{
    "location": "manual/algorithm.html#",
    "page": "Algorithm",
    "title": "Algorithm",
    "category": "page",
    "text": ""
},

{
    "location": "manual/algorithm.html#algorithm-1",
    "page": "Algorithm",
    "title": "Algorithm",
    "category": "section",
    "text": ""
},

{
    "location": "manual/build.html#",
    "page": "Build",
    "title": "Build",
    "category": "page",
    "text": ""
},

{
    "location": "manual/build.html#build-1",
    "page": "Build",
    "title": "Build",
    "category": "section",
    "text": ""
},

{
    "location": "manual/install.html#",
    "page": "Installation",
    "title": "Installation",
    "category": "page",
    "text": ""
},

{
    "location": "manual/install.html#install-1",
    "page": "Installation",
    "title": "Installation",
    "category": "section",
    "text": ""
},

{
    "location": "manual/optimization.html#",
    "page": "JuliaOptimizer",
    "title": "JuliaOptimizer",
    "category": "page",
    "text": ""
},

{
    "location": "manual/optimization.html#optimization-1",
    "page": "JuliaOptimizer",
    "title": "JuliaOptimizer",
    "category": "section",
    "text": "(main.h, main.cpp)#pragma once#include <array> #include <unordered_map>typedef void(LoopFunc)(void); typedef void(LoopFunc2)(float);#define EXPORT __declspec(dllexport)extern \"C\" {   EXPORT void* createLoop(const unsigned int, void** a, const unsigned int, LoopFunc);   EXPORT void loopByIndex(const unsigned int);   EXPORT void loopByObject(void*);   EXPORT void prepare(LoopFunc f, void** a, unsigned int count);   EXPORT void loop(); };struct loopObj {   LoopFunc loopFunc = NULL;   std::vector<void*> loopArray;   using Iterator = decltype(loopArray)::iterator;   Iterator it;   Iterator start;   Iterator end;loopObj() {}   loopObj(LoopFunc f, void** a, unsigned int count) {     loopFunc = f;     loopArray = std::vector<void*>(a, a + count);     start = loopArray.begin();     end = loopArray.end();   }void loop() {     for (it = start; it != end; ++it) loopFunc(*it);   } };std::unordered_map<unsigned int, loopObj> loopObjs;void* createLoop(const unsigned int index, void** a, const unsigned int count, LoopFunc f) {   return &(loopObjs[index] = loopObj(f, a, count)); }void loopByIndex(const unsigned int index) {   const auto& it = loopObjs.find(index);   if (it == loopObjs.end()) return;   it->second.loop(); }void loopByObject(void* iobj) {   if(!iobj) return;   ((loopObj*)iobj)->loop(); }// –––––––––––––––––––––-void prepare(LoopFunc f, void** a, unsigned int count) {   renderFun = f;   FIELDS = std::vector<void*>(a, a + count);   FSTART = FIELDS.begin();   FEND = FIELDS.end(); }void loop() {   for (FIT = FSTART; FIT != FEND; ++FIT) renderFun(*FIT); }"
},

{
    "location": "manual/references.html#",
    "page": "References",
    "title": "References",
    "category": "page",
    "text": ""
},

{
    "location": "manual/references.html#references-1",
    "page": "References",
    "title": "References",
    "category": "section",
    "text": ""
},

{
    "location": "manual/start.html#",
    "page": "Start",
    "title": "Start",
    "category": "page",
    "text": ""
},

{
    "location": "manual/start.html#start-1",
    "page": "Start",
    "title": "Start",
    "category": "section",
    "text": ""
},

{
    "location": "manual/szene.html#",
    "page": "Szene",
    "title": "Szene",
    "category": "page",
    "text": ""
},

{
    "location": "manual/szene.html#szene-1",
    "page": "Szene",
    "title": "Szene",
    "category": "section",
    "text": ""
},

]}
