import { fromFileUrl, dirname } from "https://deno.land/std/path/mod.ts";
import { v4 } from "https://deno.land/std/uuid/mod.ts";

export type Todo = {
  id: string;
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
  addTodo(todo: Todo): Todo;
  checkTodo(todo: Todo): void;
  deleteTodo(id: string): void
}

export const api: Api = {
  getTodos: () => {
    const db = read();
    return db.todos;
  },

  addTodo: (todo: Todo) => {
    const db = read();
    const uuid = v4.generate();
    const newTodo = { ...todo, id: uuid };
    const newDb = { todos: [...db.todos, newTodo] };
    save(newDb);

    return newTodo;
  },

  checkTodo: (updatedTodo: Todo) => {
    const db = read();
    const todos = db.todos.map((todo) => todo.id === updatedTodo.id ? { ...todo, isDone: !updatedTodo.isDone } : todo);
    save({todos});
  },

  deleteTodo: (id: string) => {
    const db = read();
    const todos = db.todos.filter((todo) => todo.id !== id);
    save({todos});
  }
}
