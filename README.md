Exercice «TaperJouer»
====================

Semaine: 9

Cours: [Programmation sur iPhone et iPad]

[Programmation sur iPhone et iPad]:
https://www.france-universite-numerique-mooc.fr/courses/UPMC/18001/Trimestre_2_2014/about

Établissement: [Université Pierre & Marie Curie](http://www.upmc.fr/)

Plateforme de MOOC: [FUN](https://www.france-universite-numerique-mooc.fr/)

[![Screen
capture](TaperJouerScreencapThumbnail.png)}(https://github.com/huyl/fun-upmc-iosdev-semaine9a/blob/master/TaperJouerScreencap.mp4?raw=true)

Compilation
-----------

Pour compiler:

- Il faut ouvrir le fichier `owned-TaperJouer.xcworkspace/`, pas
le project `owned-TaperJouer.xcodeproj/`.
-  Il faut être sûr de bien sélectionner le projet `owned-TaperJouer` en haut de
   la fenêtre avant de compiler.

Techniques
----------

Fonctionnalité :

- Joueur de musique (MPMusicPlayerController)
  - trouve chansons dans le terminal
  - montre la pochette de la musique
  - montre l'index de la chanson et le nombre de chansons
  - montre le progrès de la musique qui joue
- Historique de la musique
  - on peut selectionner pour re-jouer la chancer
- Gestures
  - comprend le double-tap et les swipes dans plusieurs sens pour commencer
    la musique et changer de chansons
- Universelle
  - pour l'iPad, utilise SplitViewController
  - pour l'iPhone, utilise TabBarController
  - iOS6
- Rotation

Structure :

- Organisation [Model-View-ViewModel
  (MVVM)](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/)
- Style [Functional Reactive Programming](http://en.wikipedia.org/wiki/Functional_reactive_programming) au travers de ReactiveCocoa
  - Highlight: smartly combines play signals (from double-tap) and song selection
    (from swipe or tap in history), with
    combineLatestWith/filter/map/distinctUntilChanged
- L'interface est construise programmatiquement; pas de Storyboard / Interface Builder
- Auto-Layout
- ARC, à cause de ReactiveCocoa et presque [tout le
  monde](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml?showone=Automatic_Reference_Counting__ARC_#Automatic_Reference_Counting__ARC_) l'utilise.
- Notation pointée (dot notation), parce que c'est idiomatique (comme l'explique
  [Google](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml?showone=Properties#Properties) et 
  [NY
  Times](https://github.com/NYTimes/objective-c-style-guide#dot-notation-syntax))

Librairies :

- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) :
pour UI binding et le style Functional Reactive Programming
- [Masonry](https://github.com/cloudkite/Masonry) :
pour créer facilement les contraintes pour Auto-Layout
- [cocoapods](http://cocoapods.org/) : pour gérer les paquets comme Masonry

License
-------

The MIT License (MIT)

Copyright (c) 2014 huyl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
