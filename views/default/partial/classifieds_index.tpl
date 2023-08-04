
<div class="row">
{% for classified in classifieds %}
	<div class="col-lg-4 col-sm-6" itemscope itemtype="https://schema.org/RealEstateAgent">
		<a href="{{ path('classified',classified.id,classified.slug) }}" title="{{ classified.name }}" itemprop="url" class="classifieds_index overflow_hidden {% if classified.promoted %}classifieds_index_promoted{% endif %}">
			<img src="{% if classified.thumb %}upload/photos/{{ classified.thumb }}{% else %}views/{{ settings.template }}/images/no_image.png{% endif %}"	alt="{{ classified.name }}" onerror="this.src='views/{{ settings.template }}/images/no_image.png'" itemprop="image" loading="lazy" width="500" height="400">
			<div class="classifieds_index_desc">
				<p class="name"><span itemprop="name">{{ classified.name }}</span></p>
				{% if classified.price_free %}
					<p class="price">{{ 'For free'|trans }}</p>
				{% elseif classified.price>0 %}
					<p class="price"><span itemprop="priceRange">{{ classified.price|showCurrency }}</span> {% if classified.price_negotiate %}<span class="small">({{ 'to negotiate'|trans }})</span>{% endif %}</p>
				{% endif %}
				{% if classified.category_name %}<p class="category_name">{{ classified.category_name }}</p>{% endif %}
				<p class="d-none" itemprop="address">{{ classified.address }}</p>
				<p class="d-none" itemprop="telephone">{{ classified.phone }}</p>
			</div>
		</a>
	</div>
{% endfor %}
</div>
