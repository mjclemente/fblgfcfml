/**
* Facebook Leadgen Forms - CFML
* Copyright 2022  Matthew J. Clemente, John Berquist
* Licensed under MIT (https://mit-license.org)
*/
component accessors="true" {

  property name="name"                                  default="";
  // allow_organic_lead_retrieval
  property name="allow_organic_lead"                    default="";
  property name="block_display_for_non_targeted_viewer" default="";
  property name="context_card"                          default="";
  property name="custom_disclaimer"                     default="";
  property name="follow_up_action_url"                  default="";
  property name="is_optimized_for_quality"              default="";
  property name="locale"                                default="";
  property name="privacy_policy"                        default="";
  property name="privacy_policy_url"                    default="";
  property name="question_page_custom_headline"         default="";
  property name="questions"                             default="";
  property name="thank_you_page"                        default="";
  property name="tracking_parameters"                   default="";

  /**
  * @hint No parameters can be passed to init this component. They must be built manually.
  */
  public any function init() {
    setContext_card({});
    setCustom_disclaimer({});
    setPrivacy_policy({});
    setQuestions([]);
    setThank_you_page({});
    setTracking_parameters({})
    return this;
  }

  /**
  * @hint Sets the name of LeadGen Ad Form (required)
  */
  public any function name(required string name) {
    setName(arguments.name);
    return this;
  }

  /**
  * @hint Sets the property `allow_organic_lead` to `true` in order to allow organic leads for this form.
  */
  public any function allowOrganicLead() {
    setAllow_organic_lead(true);
    return this;
  }

  /**
  * @hint Convenience method for calling `allowOrganicLead()`
  */
  public any function allowOrganicLeads() {
    return this.allowOrganicLead();
  }

  /**
  * @hint Sets the property `allow_organic_lead` to `false` in order to not allow organic leads for this form.
  */
  public any function doNotAllowOrganicLead() {
    setAllow_organic_lead(false);
  }

  /**
  * @hint Convenience method for calling `doNotAllowOrganicLead()`
  */
  public any function doNotAllowOrganicLeads() {
    return this.doNotAllowOrganicLead();
  }

  /**
  * @hint Sets the property `block_display_for_non_targeted_viewer` to `true` in order to block non-targeted viewers from seeing the Lead Ad form.
  */
  public any function blockDisplayForNonTargetedViewer() {
    setBlock_display_for_non_targeted_viewer(true);
    return this;
  }

  /**
  * @hint Convenience method for calling `blockDisplayForNonTargetedViewer()`
  */
  public any function blockDisplayForNonTargeted() {
    return this.blockDisplayForNonTargetedViewer();
  }

  /**
  * @hint Sets the property `block_display_for_non_targeted_viewer` to `false` in order to allow non-targeted viewers to see the Lead Ad form.
  */
  public any function doNotBlockDisplayForNonTargetedViewer() {
    setBlock_display_for_non_targeted_viewer(false);
    return this;
  }

  /**
  * @hint Convenience method for calling `blockDisplayForNonTargetedViewer()`
  */
  public any function doNotBlockDisplayForNonTargeted() {
    return this.doNotBlockDisplayForNonTargetedViewer();
  }

  /**
  * @hint Set the context card for this Lead Ad Form.
  * @context_card isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `context_card`.
  */
  public any function contextCard(required struct context_card) {
    setContext_card(arguments.context_card);
    return this;
  }

  /**
  * @hint Set the custom_disclaimer for this Lead Ad Form, which is part of its legal_content
  * @custom_disclaimer isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `legal_content.custom_disclaimer`.
  */
  public any function customDisclaimer(required struct custom_disclaimer) {
    setCustom_disclaimer(arguments.custom_disclaimer);
    return this;
  }

  /**
  * @hint Sets the URL that the `follow_up_action_text` will take users to on click
  */
  public any function followUpActionUrl(required string uri) {
    setFollow_up_action_url(arguments.uri);
    return this;
  }

  /**
  * @hint By default, Facebook optimizes for number of leads. Calling this method will set the property `is_optimized_for_quality` to `true`, so Facebook will instead optimize for intent.
  */
  public any function optimizeForQuality() {
    setIs_optimized_for_quality(true);
    return this;
  }

  /**
  * @hint By default, Facebook optimizes for number of leads. Calling this method will explicitly confirm that default by setting the property `is_optimized_for_quality` to `false`.
  */
  public any function optimizeForLeads() {
    setIs_optimized_for_quality(false);
    return this;
  }

  /**
  * @hint Set the Lead Ad Form locale; for example, `en_US`
  */
  public any function locale(required string locale) {
    setLocale(arguments.locale);
    return this;
  }

  /**
  * @hint Set the privacy_policy for this Lead Ad Form, which is part of its legal_content
  * @privacy_policy isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `legal_content.privacy_policy`.
  */
  public any function privacyPolicy(required struct privacy_policy) {
    setPrivacy_policy(arguments.privacy_policy);
    return this;
  }

  /**
  * @hint Set the URL to the advertiser's privacy policy
  */
  public any function privacyPolicyUrl(required string uri) {
    setPrivacy_policy_url(arguments.uri);
    return this;
  }

  /**
  * @hint Sets a custom headline for question page within a lead form
  */
  public any function questionPageCustomHeadline(required string text) {
    setQuestion_page_custom_headline(arguments.text);
    return this;
  }

  /**
  * @hint Convenience method for calling `questionPageCustomHeadline()`
  */
  public any function customHeadline(required string text) {
    return this.questionPageCustomHeadline(text = arguments.text);
  }

  /**
  * @hint Sets the questions used on the form.
  * @questions is an array of the form's questions. More information on how to create different types of questions can be found in the section "Add Questions" here: https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#adding_questions
  */
  public any function questions(required array questions) {
    setQuestions(arguments.questions);
    return this;
  }

  /**
  * @hint Sets the details for an optional customized thank you page displayed post submission.
  * @thank_you_page isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `thank_you_page`.
  */
  public any function thankYouPage(required struct thank_you_page) {
    setThank_you_page(arguments.thank_you_page);
    return this;
  }

  /**
  * @hint Sets tracking parameters to include with this form's field data.
  * @tracking_parameters is a struct of key value pairs that are not present on the form, but will be returned when you request data about the leads generated via the form. More information about these can be found in the section "Provide Tracking Parameters" here: https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#track
  */
  public any function trackingParameters(required struct tracking_parameters) {
    setTracking_parameters(arguments.tracking_parameters);
    return this;
  }

  /**
  * @hint Assembles the form struct to send to the API. Generally, you shouldn't need to call this directly.
  */
  public struct function build() {
    var body       = "";
    var properties = getPropertyValues();
    var count      = properties.len();

    // properties.each(function( property, index ) {
    //   var value = serializeJSON(property.value);
    //   // cfformat-ignore-start
    //   body &= '"#property.key#": ' & value & '#index NEQ count ? "," : ""#';
    //   // cfformat-ignore-end
    // });

    return properties.reduce(function( r, i, x ) {
      r[i.key] = i.value;
      return r;
    }, {});
  }

  private numeric function getUTCTimestamp(required date dateToConvert) {
    return dateDiff("s", variables.utcBaseDate, dateToConvert);
  }

  private date function parseUTCTimestamp(required numeric utcTimestamp) {
    return dateAdd("s", utcTimestamp, variables.utcBaseDate);
  }

  /**
  * @hint converts the array of properties to an array of their keys/values, while filtering those that have not been set
  */
  private array function getPropertyValues() {
    var propertyValues = getProperties().map(function( item, index ) {
      return {
        "key"  : item.name,
        "value": getPropertyValue(item.name)
      };
    });

    return propertyValues.filter(function( item, index ) {
      return hasValue(item.value);
    });
  }

  private array function getProperties() {
    var metaData   = getMetadata(this);
    var properties = [];

    for( var prop in metaData.properties ){
      properties.append(prop);
    }

    return properties;
  }

  private any function getPropertyValue(string key) {
    var method = this["get#key#"];
    var value  = method();
    return value;
  }

  private boolean function hasValue(any value) {
    if( isNull(value) ) return false;
    if( isSimpleValue(value) ) return len(value);
    if( isStruct(value) ) return !value.isEmpty();
    if( isArray(value) ) return value.len();

    return false;
  }

}
