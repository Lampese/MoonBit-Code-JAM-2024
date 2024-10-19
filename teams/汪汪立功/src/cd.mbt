struct CD {
  mut cd : Int
  total : Int
  decrease : Int
}

pub fn CD::new(total : Int, decrease : Int) -> CD {
  { cd: total, total, decrease }
}

pub fn decrease(self : CD) -> Unit {
  self.cd -= self.decrease
}

pub fn refersh(self : CD) -> Unit {
  self.cd = self.total
}

pub fn check(self : CD) -> Bool {
  self.cd <= 0
}
