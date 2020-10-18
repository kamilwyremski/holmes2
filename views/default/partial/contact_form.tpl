
{% if settings.recaptcha_site_key and settings.recaptcha_secret_key %}
	<script src='https://www.google.com/recaptcha/api.js'></script>
{% endif %}

<form method="post" enctype="multipart/form-data">
  <input type="hidden" name="action" value="send_message">
  <div class="form-group row">
    <label for="name" class="col-sm-4 col-md-2 col-form-label">{{ 'Name'|trans }}</label>
    <div class="col-sm-8 col-md-10">
      <input type="text" class="form-control" id="name" name="name" placeholder="{{ 'John Smith'|trans }}" required value="{{ input.name }}" title="{{ 'Name'|trans }}">
    </div>
  </div>
  <div class="form-group row {% if error.email %}was-validated{% endif %}">
    <label for="email" class="col-sm-4 col-md-2 col-form-label">{{ 'E-mail address'|trans }}</label>
    <div class="col-sm-8 col-md-10">
      <input type="email" class="form-control" id="email" name="email" placeholder="{{ 'example@example.com'|trans }}" required value="{% if input.email %}{{ input.email }}{% elseif user.id %}{{ user.email }}{% endif %}" title="{{ 'E-mail address'|trans }}" {% if user.id %}readonly{% endif %}>
      {% if error.email %}<p class="text-danger">{{ error.email }}</p>{% endif %}
    </div>
  </div>
  <div class="form-group row">
    <label for="message" class="col-sm-4 col-md-2 col-form-label">{{ 'Message'|trans }}</label>
    <div class="col-sm-8 col-md-10">
      <textarea class="form-control" rows="4" name="message" id="message" required placeholder="{{ 'Message'|trans }}" title="{{ 'Message'|trans }}">{{ input.message }}</textarea>
    </div>
  </div>
  {% if settings.mail_attachment %}
    <div class="form-group row">
      <label for="attachment" class="col-sm-4 col-md-2 col-form-label">{{ 'Attachment'|trans }}</label>
      <div class="col-sm-8 col-md-10">
        <input type="file" name="attachment" id="attachment" title="{{ 'Attachment'|trans }}" class="form-control-file">
		{% if error.attachment %}<p class="text-danger">{{ error.attachment }}</p>{% endif %}
      </div>
    </div>
  {% endif %}
	<div class="form-group row {% if error.captcha %}was-validated{% endif %}">
  	{% if settings.recaptcha_site_key and settings.recaptcha_secret_key %}
      <div class="offset-sm-4 col-sm-8 offset-md-2 col-md-10">
        <div class="g-recaptcha" data-sitekey="{{ settings.recaptcha_site_key }}"></div>
        {% if error.captcha %}<p class="text-danger">{{ error.captcha }}</p>{% endif %}
      </div>
  	{% else %}
      <label for="captcha" class="col-sm-4 col-md-2 col-form-label">{{ 'Captcha'|trans }}</label>
      <div class="col-sm-4 col-md-3">
        <img src="{{ path('captcha') }}" alt="captcha">
      </div>
      <div class="col-sm-4 col-md-7">
        <input type="text" class="form-control" placeholder="abc123" title="{{ 'Enter the code Captcha'|trans }}" name="captcha" id="captcha" required maxlength="32">
        {% if error.captcha %}<p class="text-danger">{{ error.captcha }}</p>{% endif %}
      </div>
  	{% endif %}
	</div>
  {% if not user.id %}
    <div class="form-group row">
      <div class="col-sm-8 col-md-10 offset-sm-4 offset-md-2">
        <div class="custom-control custom-checkbox">
          <input type="checkbox" name="rules" class="custom-control-input" id="contact_rules" required {% if input.rules %}checked{% endif %}>
          <label class="custom-control-label" for="contact_rules">{{ 'Accepts the terms and conditions and the privacy policy'|trans }} (<a href="{{ path('rules') }}" title="{{ 'Terms of service'|trans }}" target="_blank" class="main-color-2">{{ 'Terms of service'|trans }}</a> - <a href="{{ path('privacy_policy') }}" title="{{ 'Privacy policy'|trans }}" target="_blank" class="main-color-2">{{ 'Privacy policy'|trans }}</a>)<span class="text-danger">&nbsp;*</span></label>
        </div>
      </div>
    </div>
  {% endif %}
  <div class="form-group row">
    <div class="col-sm-8 col-md-10 offset-sm-4 offset-md-2">
      <input type="submit" value="{{ 'Send!'|trans }}" class="btn btn-2">
    </div>
  </div>
</form>
