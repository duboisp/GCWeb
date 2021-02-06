---
title: Liste des template
lang: fr
altLangPage: index-en.html
dateModified: 2021-02-05
---


Try to filter by URL.


- {{ site.data.components[ "dct:title" ].en }}
- {{ site.data.components.dct:title.en }}

{::nomarkdown}

<h2>Examples</h2>

<ul>
{% for item in site.data.components %}

	{% assign list-example = item.examples | where: "language", "en" %}

	<li>{{ item.title.en }}<ul>

	{% for example in list-example %}
		<li><a href="components/{{ item.componentName }}/{{ example.path }}">{{ example.title}}</a></li>
	{% endfor %}
	
	</ul></li>
{% endfor %}
</ul>

{:/}

----

----

----

## All pages

{% assign all_categories = site.pages | map: "category" | uniq %}

{% for item in all_categories %}

	{% assign list-pages = site.pages | where: "category", item %}
	
### {{ item | default: "Sans categorie" }}
	
	{% for pg in list-pages %}
	
* {{ pg.url }} - {{ pg.title }}
		
	{% endfor %}
	
{% endfor %}




{% assign list-templates = site.pages | where: "category", "templates" %}

### Templates 
{% for pageIterator in list-templates %}

* {{ pageIterator.title }}
* {{ pageIterator.category }} - {{ pageIterator.url }}
*

{% endfor %}
