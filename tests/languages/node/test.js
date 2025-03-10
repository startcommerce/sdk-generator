
const appwrite = require('../../sdks/node/index');
const InputFile = require('../../sdks/node/lib/inputFile');
const fs = require('fs');

async function start() {
    var response;

    let Permission = appwrite.Permission;
    let Query = appwrite.Query;
    let Role = appwrite.Role;
    let ID = appwrite.ID;

    // Init SDK
    let client = new appwrite.Client();

    let foo = new appwrite.Foo(client);
    let bar = new appwrite.Bar(client);
    let general = new appwrite.General(client);

    client.addHeader('Origin', 'http://localhost');

    console.log('\nTest Started');

    // Foo

    response = await foo.get('string', 123, ['string in array']);
    console.log(response.result);

    response = await foo.post('string', 123, ['string in array']);
    console.log(response.result);

    response = await foo.put('string', 123, ['string in array']);
    console.log(response.result);

    response = await foo.patch('string', 123, ['string in array']);
    console.log(response.result);

    response = await foo.delete('string', 123, ['string in array']);
    console.log(response.result);

    // Bar

    response = await bar.get('string', 123, ['string in array']);
    console.log(response.result);

    response = await bar.post('string', 123, ['string in array']);
    console.log(response.result);

    response = await bar.put('string', 123, ['string in array']);
    console.log(response.result);

    response = await bar.patch('string', 123, ['string in array']);
    console.log(response.result);

    response = await bar.delete('string', 123, ['string in array']);
    console.log(response.result);

    response = await general.redirect();
    console.log(response.result);

    response = await general.upload('string', 123, ['string in array'], InputFile.fromPath(__dirname + '/../../resources/file.png', 'file.png'));
    console.log(response.result);

    response = await general.upload('string', 123, ['string in array'], InputFile.fromPath(__dirname + '/../../resources/large_file.mp4', 'large_file.mp4'));
    console.log(response.result);

    try {
        response = await general.error400();
    } catch(error) {
        console.log(error.message);
    }
    
    try {
        response = await general.error500();
    } catch(error) {
        console.log(error.message);
    }
    
    try {
        response = await general.error502();
    } catch(error) {
        console.log(error.message);
    }

    await general.empty();

    // Query helper tests
    console.log(Query.equal('title', ['Spiderman', 'Dr. Strange']));
    console.log(Query.notEqual('title', 'Spiderman'));
    console.log(Query.lessThan('releasedYear', 1990));
    console.log(Query.greaterThan('releasedYear', 1990));
    console.log(Query.search('name', "john"));
    console.log(Query.orderAsc("title"));
    console.log(Query.orderDesc("title"));
    console.log(Query.cursorAfter("my_movie_id"));
    console.log(Query.cursorBefore("my_movie_id"));
    console.log(Query.limit(50));
    console.log(Query.offset(20));

    // Permission & Role helper tests
    console.log(Permission.read(Role.any()));
    console.log(Permission.write(Role.user(ID.custom('userid'))));
    console.log(Permission.create(Role.users()));
    console.log(Permission.update(Role.guests()));
    console.log(Permission.delete(Role.team('teamId', 'owner')));
    console.log(Permission.delete(Role.team('teamId')));

    // ID helper tests
    console.log(ID.unique());
    console.log(ID.custom('custom_id'));
}

start().catch((err) => {
    console.log(err);
});