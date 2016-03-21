import Ember from 'ember';
import RouteMetaDescriptionMixin from 'client/mixins/route-meta-description';
import { module, test } from 'qunit';

module('Unit | Mixin | route meta description');

// Replace this with your real tests.
test('it works', function(assert) {
  let RouteMetaDescriptionObject = Ember.Object.extend(RouteMetaDescriptionMixin);
  let subject = RouteMetaDescriptionObject.create();
  assert.ok(subject);
});
