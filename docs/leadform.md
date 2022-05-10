# `leadform.cfc` Reference

#### `name( required string name )`

Sets the name of LeadGen Ad Form (required).

#### `allowOrganicLead()`

Sets the property `allow_organic_lead` to `true` in order to allow organic leads for this form.

#### `allowOrganicLeads()`

Convenience method for calling `allowOrganicLead()`.

#### `doNotAllowOrganicLead()`

Sets the property `allow_organic_lead` to `false` in order to not allow organic leads for this form.

#### `doNotAllowOrganicLeads()`

Convenience method for calling `doNotAllowOrganicLead()`.

#### `blockDisplayForNonTargetedViewer()`

Sets the property `block_display_for_non_targeted_viewer` to `true` in order to block non-targeted viewers from seeing the Lead Ad form.

#### `blockDisplayForNonTargeted()`

Convenience method for calling `blockDisplayForNonTargetedViewer()`.

#### `doNotBlockDisplayForNonTargetedViewer()`

Sets the property `block_display_for_non_targeted_viewer` to `false` in order to allow non-targeted viewers to see the Lead Ad form.

#### `doNotBlockDisplayForNonTargeted()`

Convenience method for calling `blockDisplayForNonTargetedViewer()`.

#### `contextCard( required struct context_card )`

Set the context card for this Lead Ad Form. The parameter `context_card` isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `context_card`.

#### `customDisclaimer( required struct custom_disclaimer )`

Set the custom_disclaimer for this Lead Ad Form, which is part of its legal_content. The parameter `custom_disclaimer` isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `legal_content.custom_disclaimer`.

#### `followUpActionUrl( required string uri )`

Sets the URL that the `follow_up_action_text` will take users to on click.

#### `optimizeForQuality()`

By default, Facebook optimizes for number of leads. Calling this method will set the property `is_optimized_for_quality` to `true`, so Facebook will instead optimize for intent.

#### `optimizeForLeads()`

By default, Facebook optimizes for number of leads. Calling this method will explicitly confirm that default by setting the property `is_optimized_for_quality` to `false`.

#### `locale( required string locale )`

Set the Lead Ad Form locale; for example, `en_US`.

#### `privacyPolicy( required struct privacy_policy )`

Set the privacy_policy for this Lead Ad Form, which is part of its legal_content. The parameter `privacy_policy` isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `legal_content.privacy_policy`.

#### `privacyPolicyUrl( required string uri )`

Set the URL to the advertiser's privacy policy.

#### `questionPageCustomHeadline( required string text )`

Sets a custom headline for question page within a lead form.

#### `customHeadline( required string text )`

Convenience method for calling `questionPageCustomHeadline()`.

#### `questions( required array questions )`

Sets the questions used on the form. The parameter `questions` is an array of the form's questions. More information on how to create different types of questions can be found in the section "Add Questions" here: https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#adding_questions.

#### `thankYouPage( required struct thank_you_page )`

Sets the details for an optional customized thank you page displayed post submission. The parameter `thank_you_page` isn't well documented. Your best bet is probably creating a form manually through the Facebook interface and then querying it via the API to see the shape of the returned `thank_you_page`.

#### `trackingParameters( required struct tracking_parameters )`

Sets tracking parameters to include with this form's field data. The parameter `tracking_parameters` is a struct of key value pairs that are not present on the form, but will be returned when you request data about the leads generated via the form. More information about these can be found in the section "Provide Tracking Parameters" here: https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#track.

#### `build()`

Assembles the form struct to send to the API. Generally, you shouldn't need to call this directly.
