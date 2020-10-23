import { opine, serveStatic } from "https://deno.land/x/opine@0.24.0/mod.ts";
import { dirname, fromFileUrl } from "https://deno.land/std/path/mod.ts";
import { api } from '../db/index.ts';

const PORT = 3000;

const app = opine();
const root = fromFileUrl(dirname(import.meta.url));

app.use(serveStatic(`${root}/../../client/dist`));

app.get('/', (req, res) => {
  res.sendFile(`${root}/../../client/dist/index.html`);
});

app.get('/todos', (req, res) => {
  const todos = api.getTodos();
  res.send(todos);
});

app.listen(PORT, () => console.log('Server is up'));
