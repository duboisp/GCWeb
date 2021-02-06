---
title: "@ Example pour la création de composant méli-mélo"
lang: fr
altLangPage: index-en.html
dateModified: 2021-02-06
script: wb-bonjour.js
css: wb-bonjour.css
---

Ceci est un example afin de démontrer la structure nécessaire pour procéder à la création de composant méli-mélo.

Ces composant sont complétement *détaché* du thème de Canada.ca. Par contre, les modules récent et répondant au exigence minimal seront assemblé ensemble et publié sur Canada.ca en tant que fichier indépendant.

Les exigences minimal c'est:

* Une démostration existe pour chaques fonctionalité afin de mettre à l'essaie  inclus dans ce méli-mélo.
* Il ne doit pas interférer, ni remplacer n'importe lequel partie des libraries de la BOEW, du thème de Canada.ca ni avec les méli-mélo dans son ensemble.
* Une revision préalable qui sera brève et partielle sera fait afin de repérer des erreurs d'accessibilité majeur et flagrant.
* Le propriétaire de contenu duquel le méli-mélo sera utilisé en production prendra toutes les mesures nécessaire pour une conformance et assumera l'entièreté des risques.
* Toutes fonctionalité méli-mélo est asujeti à l'approbation et au droit de vétaux des administrateurs de la BOEW.
* Ces fonctionalités doivent répondre à un besoin d'un département asujeti à la politique des communications du gouvernement du Canada.

Vous pouvez aussi inclure:
* Vos documents sommaire de recherche utilisateur
* Identifier une personne resource ou un département.
* Vos rapport de mise à l'essaie

L'autre étape après le méli-mélo, c'est la promotion de la fonctionalité, en format entreprise, afin qu'il soit intégré avec le thème de Canada.ca.

----

## Démonstration du composant expérimental: Bonjour le monde

Un CSS personalisé a été compilé par le thème jekyll. La grosseur de la police a été augmenté de 200%.

{::nomarkdown}
<div class="well">
	<p class="wb-bonjour">Exemple 1</p>
	<p>Exemple 2 (<em class="wb-bonjour">à l'intérieur d'un em</em>)</p>
	<p class="wb-bonjour" data-wb-bonjour='{ "surpassetoi": true }'>Exemple 3 avec paramètre</p>
</div>
{:/}

### Code source

```
<p class="wb-bonjour">Exemple 1</p>
<p>Exemple 2 (<em class="wb-bonjour">à l'intérieur d'un em</em>)</p>
<p class="wb-bonjour" data-wb-bonjour='{ "surpassetoi": true }'>Exemple 3 avec paramètre</p>

```

* [Fichier CSS générer par Jekyll](wb-bonjour.css)
* [Fichier JS](wb-bonjour.js)
