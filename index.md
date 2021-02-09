---
title: GC Web
altLangPage: index.html
dateModified: 2020-01-10
description: "Page d'index pour GCWeb"
lang: fr
---
{::nomarkdown}
<h2>Components</h2>

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

<h2>Templates</h2>
<ul>
{% for templatePg in site.data.templates.pages %}
	<li><a href="templates/{{ templatePg.url }}">{{ templatePg.title }}</a></li>
{% endfor %}
</ul>


<h2>Provisional feature</h2>

<h2>Méli-mélo packages</h2>
<ul>
{% for item in site.data[ "mli-mlo" ].packages %}
	<li>{{ item.nom }}
		<ul>
		{% for pack in item.libs %}
			<li><a href="méli-mélo/demos/{{ item.nom }}/{{ pack }}/">{{ pack }}</a></li>
		{% endfor %}
		</ul>
	</li>
{% endfor %}
</ul>


<h3>Méli-mélo sub-projects</h3>
<ul>
{% for item in site.data[ "mli-mlo" ].subProjects %}
	<li><a href="méli-mélo/{{ item.nom }}/{{ item.mainpage }}">{{ item.nom }}</a></li>
{% endfor %}
</ul>


{:/}
