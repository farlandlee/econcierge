import { moduleFor, test } from 'ember-qunit';

moduleFor('route:activity/category/experience/product', 'Unit | Route | activity/category/experience/product', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});

test('it serializes experiences by slug', function(assert) {
  let route = this.subject();
  let fakeExperience = {
    get (field) { return field; }
  };
  let result = route.serialize(fakeExperience);
  assert.equal(result.experience_slug, 'slug');
});
