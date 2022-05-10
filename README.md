# Facebook Leadgen Forms - CFML

A CFML wrapper for the [Facebook Leadgen Forms API](https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create).
Create and manage Facebook's lead forms via their marketing API.

*Feel free to use the issue tracker to report bugs or suggest improvements!*

## Acknowledgements

This project borrows heavily from the API frameworks built by [jcberquist](https://github.com/jcberquist). Thanks to John for all the inspiration!

## Table of Contents

- [Quick Start](#quick-start)
- [Setup and Authentication](#setup-and-authentication)
- [`Facebook Leadgen Forms - CFML` Reference Manual](#reference-manual)
- [Reference Manual for `helpers.leadform`](#reference-manual-for-helpersleadform)

## Quick Start

The CFC is used to interact with the Lead Gen Forms in a Facebook account. Here's how you use it, along with the helper component for building lead gen forms:

```cfc
fblgf = new path.to.fblgfcfml.facebookleadgenforms( access_token = 'xxx', page_id = 'xxx' );

leadgenform = new path.to.fblgfcfml.helpers.leadform()
  .name('Test Form')
  .followUpActionUrl('https://www.follow-up.com/here')
  .questions([{"type":"EMAIL"}])
  .contextCard({"title": "Greetings!", "content": ["First thing to say", "Second item"],"style": "LIST_STYLE"})
  .privacyPolicy({"url": "https://termly.io/products/privacy-policy-generator/", "link_text": "View this test Privacy Notice"});

res = fblgf.create( leadgenform );
writeDump( var='#res#', abort='true' );
```

And here's how you use to list the existing forms in your account:

```cfc
fblgf = new path.to.fblgfcfml.facebookleadgenforms( access_token = 'xxx', page_id = 'xxx' );

forms = fblgf.listByPage();
writeDump( var='#forms#', abort='true' );
```

### Setup and Authentication

To get started with using Facebook Leadgen Forms via their API, you'll need an Access Token and Page ID (along with a Facebook App). The full requirements, along with further details, can be found [here](https://developers.facebook.com/docs/marketing-api/guides/lead-ads#reqs).

Once you have the token and Page ID, you can provide them to this wrapper manually when creating the component, as in the Quick Start example above, or via environment variables named `FACEBOOKLEADGENFORMS_ACCESS_TOKEN` and `FACEBOOKLEADGENFORMS_PAGE_ID`, which will get picked up automatically. This latter approach is generally preferable, as it keeps hardcoded credentials out of your codebase.

### Reference Manual

#### `listAvailableFields()`

Lists all available fields for Lead Gen Data. *[Further docs](https://developers.facebook.com/docs/graph-api/reference/lead-gen-data/)*

#### `listByPage( any fields )`

Retrieves a list of all forms available on a Page. The parameter `fields` returns all available fields if set to `all`. Otherwise it can be left blank, or provided a list/array of the fields required. *[Further docs](https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#readform)*

#### `create( required any leadform )`

Create a lead form with questions you can display in lead ads. The parameter `leadform` expects an instance of the `helpers.leadform` component, but you can construct the struct yourself if you prefer. *[Further docs](https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#lead_form)*

#### `archive( required numeric form_id )`

Archive a lead form. *[Further docs](https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#archiveform)*

### Reference Manual for `helpers.leadform`

The reference manual for all public methods in `helpers/leadform.cfc` can be found in the `docs` directory, [in `leadform.md`](https://github.com/mjclemente/fblgfcfml/blob/main/docs/leadform.md). All methods are chainable.

---
