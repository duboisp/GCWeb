---
title: Liste des template
lang: fr
altLangPage: index-en.html
dateModified: 2021-02-05
---

List of templates

{{ site.categories }}

{% for cat in site.categories %}

	<h3>{{ cat[0] }}</h3>
	<ul>
		{% for post in tag[ 1 ] %}
			<li><a href="{{ post.url }}">{{ post.title }}</a></li>
		{% endfor %}
	</ul>
{% endfor %}
