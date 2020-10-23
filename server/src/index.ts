import { opine, serveStatic, urlencoded, json } from "https://deno.land/x/opine@0.24.0/mod.ts";
import { dirname, fromFileUrl } from "https://deno.land/std/path/mod.ts";
import { api, Todo } from '../db/index.ts';

const PORT = 3000;

const app = opine();
const root = fromFileUrl(dirname(import.meta.url));

app.use(serveStatic(`${root}/../../client/dist`));
app.use(json());
app.use(urlencoded());

app.get('/', (req, res) => {
  res.sendFile(`${root}/../../client/dist/index.html`);
});

app.post('/', (req, res) => {
  const todo: Todo = req.parsedBody;
  const newTodo = api.addTodo(todo);
  res.send(newTodo);
});

app.put('/', (req, res) => {
  const todo: Todo = req.parsedBody;
  api.checkTodo(todo);
});

app.delete('/:id', (req, res) => {
  const idToDelete = req.params.id;
  api.deleteTodo(idToDelete);
});

app.get('/todos', (req, res) => {
  const todos = api.getTodos();
  res.send(todos);
});

app.listen(PORT, () => console.log('Server is up'));
