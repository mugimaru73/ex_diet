<template>
  <tr>
    <td>
      <ingredients-search-input
        ref="ingredientSearchInput"
        @focusLost="onIngredientsSearchFocusLost"
        :allow-add-new="true"
        v-model="value.ingredient"
        :state="!this.v.ingredient.name.$invalid"
      />
    </td>
    <td>
      <b-input
        ref="weightInput"
        type="number"
        @focus="$event.target.select()"
        v-model="value.weight"
        :state="!this.v.weight.$invalid"
      ></b-input>
    </td>
    <template v-if="value.ingredient && value.ingredient.id">
      <td>{{ protein }}</td>
      <td>{{ fat }}</td>
      <td>{{ carbonhydrate }}</td>
      <td>{{ energy }}</td>
    </template>
    <template v-if="value.ingredient && !value.ingredient.id">
      <td>
        <b-input
          v-model="value.ingredient.protein"
          type="text"
          :state="vuelidate_ingredient('protein')"
        ></b-input>
      </td>
      <td>
        <b-input
          v-model="value.ingredient.fat"
          type="text"
          :state="vuelidate_ingredient('fat')"
        ></b-input>
      </td>
      <td>
        <b-input
          v-model="value.ingredient.carbonhydrate"
          type="text"
          :state="vuelidate_ingredient('carbonhydrate')"
        ></b-input>
      </td>
      <td>
        <b-input
          v-model="value.ingredient.energy"
          type="text"
          :state="vuelidate_ingredient('energy')"
        ></b-input>
      </td>
    </template>
    <template v-if="!value.ingredient">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </template>
    <td>
      <b-button
        tabindex="-1"
        variant="outline-danger"
        @click="$emit('delete')"
      >Delete</b-button>
    </td>
  </tr>
</template>

<script>
import ingredientsSearchInput from '@/components/ingredients/SearchInput.vue';

function calculateNutritionFact(item, field, prescision) {
  if (!item.ingredient || !item.ingredient[field]) {
    return null;
  }
  if (item.weight === 0) {
    return 0;
  }
  return (item.ingredient[field] * item.weight / 100).toFixed(prescision);
}
export default {
  name: 'ingredients-form-row',
  components: {
    'ingredients-search-input': ingredientsSearchInput,
  },
  data() {
    return {};
  },
  props: {
    value: { type: Object },
    v: { required: true },
  },
  computed: {
    protein() {
      return calculateNutritionFact(this.value, 'protein', 2);
    },
    fat() {
      return calculateNutritionFact(this.value, 'fat', 2);
    },
    carbonhydrate() {
      return calculateNutritionFact(this.value, 'carbonhydrate', 2);
    },
    energy() {
      return calculateNutritionFact(this.value, 'energy', 0);
    },
  },
  methods: {
    vuelidate_ingredient(attr) {
      if (!this.v) {
        return true;
      }
      return !this.v.ingredient[attr].$invalid;
    },
    focus() {
      this.$refs.ingredientSearchInput.focus();
    },
    onIngredientsSearchFocusLost() {
      this.$refs.weightInput.focus();
    },
  },
};
</script>
