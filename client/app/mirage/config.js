export default function() {

  this.namespace = '/web_api';
  this.timing = 400; //delay response 400ms
  /*
    GET shorthands

    // Collections
    this.get('/contacts');
    this.get('/contacts', 'users');
    this.get('/contacts', ['contacts', 'addresses']);

    // Single objects
    this.get('/contacts/:id');
    this.get('/contacts/:id', 'user');
    this.get('/contacts/:id', ['contact', 'addresses']);
  */
  /*
    Function fallback. Manipulate data in the db via

      - db.{collection}
      - db.{collection}.find(id)
      - db.{collection}.where(query)
      - db.{collection}.update(target, attrs)
      - db.{collection}.remove(target)
  */
  this.get('/activities', function (db, req) {
    let slug = req.queryParams.slug;
    return {activity: db.activities.where({slug: slug})};
  });

  this.get('/categories', function (db, req) {
    let slug = req.queryParams.slug;
    let activity_id = req.queryParams.activity_id;
    return {
      category: db.categories.where({
        slug: slug,
        activity_id: activity_id
      })
    };
  });

  this.get('/experiences', function (db, req) {
    //@TODO use the other two params
    // req.queryParams.category_id,
    // req.queryParams.date
    return {
      experiences: db.experiences.where({
        activity_id: req.queryParams.activity_id
      })
    };
  });
}
