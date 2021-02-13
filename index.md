---
title: GC Web
altLangPage: index.html
dateModified: 2020-01-10
description: "Page d'index pour GCWeb"
lang: fr
---
{::nomarkdown}
<h2>Components</h2>

{% assign page_group = site.data.i18n.page_group[ page.lang ] %}
{% assign comp_status = site.data.i18n.component_status[ page.lang ] %}

<ul>
{% for item in site.data.components %}
	{% assign list-pages = item.pages %}
	<li>{{ item.title.fr }} (État: {{ comp_status[ item.status ] | default: "Non définie" }})
	<ul>
	{% for pgGroup in list-pages %}
		{% assign grpkey = pgGroup[0] %}
		<li>{{ page_group[ grpkey ] | default: "Groupe inconnu" }}
			<ul>
			{% for example in pgGroup[1] %}
			  {% if example.path %}
				<li><a href="components/
							{%- if item.componentName -%}
								{{ item.componentName }}/
							{%- endif -%}
						{{ example.path }}" lang="{{ example.language }}" hreflang="{{ example.language }}">{{ example.title }}</a></li>
			  {% elsif example.url %}
					<li><a href="{{ example.url }}" lang="{{ example.language }}" hreflang="{{ example.language }}">{{ example.title }}</a></li>
			  {% else %}
					<li>{{ example.title }}</li>
			  {% endif %}
			{% endfor %}
			</ul>
		</li>
	{% endfor %}
	</ul></li>
{% endfor %}
</ul>


<h2>Templates</h2>
<ul>
{% for item in site.data.templates %}
	{% assign list-pages = item.pages %}
	<li>{{ item.title.fr }} (État: {{ comp_status[ item.status ] | default: "Non définie" }})
	<ul>
	{% for pgGroup in list-pages %}
		{% assign grpkey = pgGroup[0] %}
		<li>{{ page_group[ grpkey ] | default: "Groupe inconnu" }}
			<ul>
			{% for example in pgGroup[1] %}
			  {% if example.path %}
				<li><a href="templates/
							{%- if item.componentName -%}
								{{ item.componentName }}/
							{%- endif -%}
						{{ example.path }}" lang="{{ example.language }}" hreflang="{{ example.language }}">{{ example.title }}</a></li>
			  {% elsif example.url %}
					<li><a href="{{ example.url }}" lang="{{ example.language }}" hreflang="{{ example.language }}">{{ example.title }}</a></li>
			  {% else %}
					<li>{{ example.title }}</li>
			  {% endif %}
			{% endfor %}
			</ul>
		</li>
	{% endfor %}
	</ul></li>
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
