
<div class="row">
{% for classified in classifieds %}
	<div class="col-lg-4 col-sm-6" itemscope itemtype="https://schema.org/RealEstateAgent">
		<a href="{{ path('classified',classified.id,classified.slug) }}" title="{{ classified.name }}" itemprop="url" class="classifieds_index overflow_hidden {% if classified.promoted %}classifieds_index_promoted{% endif %}">
			<img {% if classified.thumb %}class="lazy" data-src="upload/photos/{{ classified.thumb }}"{% endif %} src="views/{{ settings.template }}/images/no_image.png"
				alt="{{ classified.name }}" onerror="this.src='views/{{ settings.template }}/images/no_image.png'" itemprop="image">
			<div class="classifieds_index_desc">
				<h5><span itemprop="name">{{ classified.name }}</span></h5>
				{% if classified.price_free %}
					<h6>{{ 'For free'|trans }}</h6>
				{% elseif classified.price>0 %}
					<h6><span itemprop="priceRange">{{ classified.price|showCurrency }}</span> {% if classified.price_negotiate %}<span class="small">({{ 'to negotiate'|trans }})</span>{% endif %}</h6>
				{% endif %}
				{% if classified.category_name %}<p class="category_name">{{ classified.category_name }}</p>{% endif %}
				<p class="d-none" itemprop="address">{{ classified.address }}</p>
				<p class="d-none" itemprop="telephone">{{ classified.phone }}</p>
			</div>
		</a>
	</div>
{% endfor %}
</div>
