import { fromFileUrl, dirname } from "https://deno.land/std/path/mod.ts";

export type Todo = {
  content: string;
  isDone: boolean;
};

export type DB = { todos: Todo[] };

const root = fromFileUrl(dirname(import.meta.url));

function read(): DB {
  return JSON.parse(Deno.readTextFileSync(`${root}/db.json`));
}

function save(db: DB) {
  Deno.writeTextFileSync(`${root}/db.json`, JSON.stringify(db, null, 2));
}

export interface Api {
  getTodos(): Todo[];
  addTodo(todo: Todo): void;
}

export const api: Api = {
  getTodos: () => {
    const db = read();
    return db.todos;
  },

  addTodo: (todo: Todo) => {
    const db = read();
    const newDb = { todos: [...db.todos, todo] };
    save(newDb);
  }
}
