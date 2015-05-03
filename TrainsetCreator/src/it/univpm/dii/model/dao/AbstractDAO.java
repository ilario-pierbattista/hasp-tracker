package it.univpm.dii.model.dao;

/**
 * Created by ilario
 * on 03/05/15.
 */
abstract public class AbstractDAO<T> {
    abstract public T find(int id);
    abstract public AbstractDAO<T> create(T e);
    abstract public AbstractDAO<T> update(T e);
    abstract public AbstractDAO<T> remove(T e);
}
