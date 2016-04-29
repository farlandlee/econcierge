import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('activity-navigator-bar', 'Integration | Component | activity navigator bar', {
  integration: true
});

test('it renders', function(assert) {
  this.setProperties({
    activity: {
      id: 'act-id',
      name: 'act name',
      slug: 'act-slug',
      categories: []
    },
    category: {
      name: 'cat name',
      slug: 'cat-slug'
    },
    activities: []
  });
  this.render(hbs`
    {{activity-navigator-bar
      activities=activities
      currentActivity=activity
      currentCategory=category}}
  `);

  assert.equal(this.$('.select-activity p').text().trim(), 'Activity:');
  assert.equal(this.$('.current').text().trim(), 'act name - cat name');
});
